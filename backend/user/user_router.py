from fastapi import FastAPI, APIRouter, HTTPException, Depends, Response, Request,Security
from fastapi.responses import JSONResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from dotenv import load_dotenv
load_dotenv()

from pydantic import BaseModel
from typing import Optional, List

from sqlalchemy.orm import Session
from database import get_userdb, get_taxidb
from models import User as User_model, Taxi as Taxi_model
import os

# 비밀번호 해싱
from passlib.context import CryptContext
from user.user_schema import User, Taxi, Login_user, modify_password, check_certification_email, certification_email
from typing import Union
from datetime import datetime, timedelta

import jwt
from jwt import PyJWTError

# email 인증
from send_email import send_message, check_num

SECRET_KEY = os.environ.get("JWT_SECRET_KEY")
ALGORITHM = os.environ.get("ALGORITHM")

ACCESS_TOKEN_EXPIRE_MINUTES = int(os.environ.get("ACCESS_TOKEN_EXPIRE_MINUTES"))
REFRESH_TOKEN_EXPIRE_MINUTES = int(os.environ.get("REFRESH_TOKEN_EXPIRE_MINUTES"))


bcrypt_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
security = HTTPBearer()


router = APIRouter(
    prefix="/user",
)


class TokenRefreshRequest(BaseModel):
    refresh_token: str

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def create_refresh_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def decode_jwt(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="토큰이 만료되었습니다.")
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="인식되지 않는 토큰입니다.")

def get_current_user(credentials: HTTPAuthorizationCredentials = Security(security), db: Session = Depends(get_userdb)):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id: str = payload.get("sub")
    if user_id is None:
        raise HTTPException(status_code=401, detail="Invalid token")
    user = get_user(user_id, db)
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    return user



# user_id가 일치한 값을 불러옴 
def get_user(user_id, db: Session):
    user = db.query(User_model).filter(User_model.user_id == user_id).first()
    if user:
        return user # -> check_user : id중복확인
    else:
        return None 
# 비밀번호 검증 
def verify_password(password, db_password):
    return bcrypt_context.verify(password, db_password)

# hash 설정
def get_hash_password(password):
    return bcrypt_context.hash(password)

@router.get("/check_token")
def check_token(credentials: HTTPAuthorizationCredentials = Security(security)):
    token = credentials.credentials
    try:
        payload = decode_jwt(token)
        return {"status": "valid", "user_id": payload.get("sub")}
    except HTTPException as e:
        return {"status": "invalid", "detail": e.detail}


# signin taxi
@router.post("/signin", response_model=Union[User, Taxi])
def signin_user(user: Taxi, 
                user_db: Session = Depends(get_userdb),
                taxi_db: Session = Depends(get_taxidb)):
    check_user = get_user(user.user_id, user_db) # user가 table에 있는지 확인
    if check_user:
        raise HTTPException(status_code=409, detail="해당 아이디는 이미 존재합니다")
    
    # db에 user를 추가
    if user.user_type == 1: # 유저
        create_user = User_model(user_id=user.user_id, 
                   password=get_hash_password(user.password),
                   nickname=user.nickname, 
                   phone_number=user.phone_number,
                   student_address=user.student_address,
                   email = user.email,
                   user_type=user.user_type)

    elif user.user_type == 0: # 택시 기사
        create_user = User_model(user_id=user.user_id, 
                   password=get_hash_password(user.password),
                   nickname=user.nickname, 
                   phone_number=user.phone_number,
                   student_address=user.student_address,
                   user_type=user.user_type)
        
        create_taxi = Taxi_model(user_id = user.user_id,
                                 driver_name = user.nickname,
                                 car_num = user.car_num, 
                                 car_model = user.car_model) 
            
        taxi_db.add(create_taxi)
        taxi_db.commit()
        taxi_db.refresh(create_taxi)
        
    user_db.add(create_user)
    user_db.commit()
    user_db.refresh(create_user)
    
    return create_user



@router.post("/send_certification_number")
async def certification_number(email : certification_email):
    try:
        number = send_message(email.email)
    except Exception as e:
        print("error :", e)
    return number

# 이메일 인증
@router.post("/check_number")
async def check_certification_number(number : check_certification_email):
    try:
        chenck_number = check_num["number"]

        if number.number != chenck_number:
            raise HTTPException(status_code=400, detail="인증번호가 틀렸습니다.")
        return {"message":"인증성공"}
        
    except Exception as e:
        print("error :", e)

# login : 로그인
@router.post("/login")
def login_user(user: Login_user, response: Response, db: Session = Depends(get_userdb)):
    check_user = get_user(user.user_id, db)

    if not check_user:
        raise HTTPException(status_code=410, detail="존재하지 않는 ID입니다.")
    elif not verify_password(user.password, check_user.password):  # 비밀번호 검증(입력 pw, db pw)
        raise HTTPException(status_code=410, detail="비밀번호가 틀렸습니다.")
    else:
        # access 토근 생성
        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user.user_id}, expires_delta=access_token_expires
        )
        # refresh 토큰 생성
        refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)
        refresh_token = create_refresh_token(
            data={"sub": user.user_id}, expires_delta=refresh_token_expires
        )

        return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}



@router.post("/token/refresh")
def refresh_token(request: TokenRefreshRequest):
    # 리프레시 토큰 검증
    try:
        payload = decode_jwt(request.refresh_token)
    except HTTPException:
        raise HTTPException(status_code=401, detail="인식되지 않는 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    # 새 액세스 토큰 발급
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    new_access_token = create_access_token(
        data={"sub": user_id}, expires_delta=access_token_expires
    )
    
    # 새 리프레시 토큰 발급 (선택 사항, 기존 리프레시 토큰을 유지하고 싶다면 이 부분은 생략 가능)
    refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)
    new_refresh_token = create_refresh_token(
        data={"sub": user_id}, expires_delta=refresh_token_expires
    )
    
    return {
        "access_token": new_access_token,
        "refresh_token": new_refresh_token,
        "token_type": "bearer"
    }


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

@router.post("/brr_cash")
def charge_brr_cash(
        amount:int,
        credentials: HTTPAuthorizationCredentials = Security(security), 
        user_db: Session = Depends(get_userdb)):
    
    user = get_current_user(credentials, user_db)

    user_info = user_db.query(User_model).filter(User_model.user_id == user.user_id).first()

    if user_info:
        current_amout = user_info.brr_cash 
        user_info.brr_cash  = current_amout + amount
        user_db.commit()

    return user_info

@router.get("/get_brr_cash")
def brr_cash(        
    credentials: HTTPAuthorizationCredentials = Security(security), 
    user_db: Session = Depends(get_userdb)):

    user = get_current_user(credentials, user_db)
    user_info = user_db.query(User_model).filter(User_model.user_id == user.user_id).first()
    return user_info.brr_cash