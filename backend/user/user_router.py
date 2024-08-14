

from fastapi import FastAPI, APIRouter, HTTPException, Depends, Response, Request,Security
from fastapi.responses import JSONResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials


from pydantic import BaseModel
from typing import Optional, List

from sqlalchemy.orm import Session
from database import get_userdb
from models import User as User_model
import os

# 비밀번호 해싱
from passlib.context import CryptContext
from user.user_schema import User, Login_user, modify_password


from datetime import datetime, timedelta

import jwt
from jwt import PyJWTError
SECRET_KEY = os.environ.get("JWT_SECRET_KEY")
ALGORITHM = os.environ.get("ALGORITHM")

ACCESS_TOKEN_EXPIRE_MINUTES = int(os.environ.get("ACCESS_TOKEN_EXPIRE_MINUTES"))
# REFRESH_TOKEN_EXPIRE_MINUTES = int(os.environ.get("REFRESH_TOKEN_EXPIRE_MINUTES"))


bcrypt_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
security = HTTPBearer()


router = APIRouter(
    prefix="/user",
)


class Token(BaseModel):
    access_token: str
    token_type: str


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    print(f"Encoded JWT: {encoded_jwt}") 
    return encoded_jwt

def decode_jwt(token: str):
    print("decode_jwt")
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        print(f"Decoded payload: {payload}")  
        return payload
    except jwt.ExpiredSignatureError:
        print("Token has expired")
        raise HTTPException(status_code=401, detail="토큰이 만료되었습니다.")
    except jwt.PyJWTError:
        print("Invalid token")  
        raise HTTPException(status_code=401, detail="인식되지 않는 토큰입니다.")

def get_current_user(credentials: HTTPAuthorizationCredentials = Security(security), db: Session = Depends(get_userdb)):
    token = credentials.credentials
    print(f"Received Token: {token}")  # 디버그 프린트
    payload = decode_jwt(token)
    print(f"Payload: {payload}")  # 디버그 프린트
    user_id: str = payload.get("sub")
    print(f"User ID from Token: {user_id}")  # 디버그 프린트
    if user_id is None:
        raise HTTPException(status_code=401, detail="Invalid token")
    user = get_user(user_id, db)
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    return user


# 모든 유저를 불러옴
def get_all_user(db: Session):
    return db.query(User_model).order_by(User_model.id.desc()).all() # model의 class를 들고와야함

# user_id가 일치한 값을 불러옴 
def get_user(user_id, db: Session):
    user = db.query(User_model).filter(User_model.user_id == user_id).first()
    print(user)
    if user:
        return user # -> check_user : id중복확인
    else:
        return None 
# 비밀번호 검증 
def verify_password(password, db_password):
    return bcrypt_context.verify(password, db_password)

# hasg 설정
def get_hash_password(password):
    return bcrypt_context.hash(password)

# 모든 유저를 불러옴
@router.get("/users", response_class=JSONResponse)
def read_users(db: Session = Depends(get_userdb)):
    data = get_all_user(db)
    return data

@router.get("/check_token")
def check_token(credentials: HTTPAuthorizationCredentials = Security(security)):
    token = credentials.credentials
    try:
        payload = decode_jwt(token)
        return {"status": "valid", "user_id": payload.get("sub")}
    except HTTPException as e:
        return {"status": "invalid", "detail": e.detail}


# signin user : 회원가입
@router.post("/signin", response_model=User)
def signin_user(user: User, db: Session = Depends(get_userdb)):
    check_user = get_user(user.user_id, db) # user가 table에 있는지 확인
    print(check_user)
    if check_user:
        raise HTTPException(status_code=409, detail="해당 아이디는 이미 존재합니다")
    
    # db에 user를 추가
    create_user = User_model(user_id=user.user_id, 
                   password=get_hash_password(user.password),
                   nickname=user.nickname, 
                   phone_number=user.phone_number,
                   student_address=user.student_address,
                   user_type=user.user_type)
    db.add(create_user)
    db.commit()
    db.refresh(create_user)
    
    return create_user

# login : 로그인
@router.post("/login")
def login_user(user: Login_user, response: Response, db: Session = Depends(get_userdb)):
    check_user = get_user(user.user_id, db)

    if not check_user:
        raise HTTPException(status_code=410, detail="존재하지 않는 ID입니다.")
    elif not verify_password(user.password, check_user.password):  # 비밀번호 검증(입력 pw, db pw)
        raise HTTPException(status_code=410, detail="비밀번호가 틀렸습니다.")
    else:
        # 토근 생성

        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user.user_id}, expires_delta=access_token_expires
        )

        return {"access_token": access_token, "token_type": "bearer"}

# 로그아웃
@router.post("/logout")
def logout_user(response: Response, requset: Request):
    access_token = requset.cookies.get("access_token")

    # 쿠키 삭제
    response.delete_cookie(key="access_token")
    
    return HTTPException(status_code=200, detail="로그아웃 성공")

# 유저 정보 삭제 : 아이디와 비밀번호 입력
@router.delete("/delete_user")
def delete_user(user: Login_user, db: Session = Depends(get_userdb)):
    check_user = db.query(User_model).filter(User_model.user_id == user.user_id)

    if not check_user.first():
        raise HTTPException(status_code=409, detail="id를 다시 입력새주세요")
    elif verify_password(user.password, check_user.first().password):
        delete_user = check_user.delete()
        db.commit()
        # db.refresh(delete_user)
        raise HTTPException(status_code=200, detail="회원정보가 삭제되었습니다.")
    else:
        raise HTTPException(status_code=409, detail="비밀번호가 틀렸습니다.")


# 유저 비밀번호 변경 : 기존 비밀번호, 새로운 비밀번호
@router.put("/modify_pw")
def modify_pw_(user: modify_password, 
              credentials: HTTPAuthorizationCredentials = Security(security), 
              db: Session = Depends(get_userdb)):
    token = credentials.credentials
    print("token :", 1)
    
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    user_info = db.query(User_model).filter(User_model.user_id == user_id).one_or_none()
    if not user_info:
        raise HTTPException(status_code=404, detail="사용자를 찾을 수 없습니다.")

    if not verify_password(user.password, user_info.password):
        raise HTTPException(status_code=400, detail="현재 비밀번호가 올바르지 않습니다.")
    
    user_info.password = get_hash_password(user.new_password)
    db.commit()
    db.refresh(user_info)
    
    return {"status": "success", "detail": "정상적으로 비밀번호가 변경되었습니다."}
