# fastapi 
from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

# db
from sqlalchemy.orm import Session
from database import get_userdb, get_taxidb
from models import User as User_model, Taxi as Taxi_model

# user
from user.user_schema import User, Taxi, Login_user, modify_password, check_certification_email, certification_email, TokenRefreshRequest
from user.user_func import decode_jwt, get_user, get_hash_password, verify_password, create_access_token, create_refresh_token, get_current_user

# email 인증
from send_email import send_message

# env
import os
from dotenv import load_dotenv
load_dotenv()

from datetime import timedelta

ACCESS_TOKEN_EXPIRE_MINUTES = int(os.environ.get("ACCESS_TOKEN_EXPIRE_MINUTES"))
REFRESH_TOKEN_EXPIRE_MINUTES = int(os.environ.get("REFRESH_TOKEN_EXPIRE_MINUTES"))


security = HTTPBearer()


router = APIRouter(
    prefix="/user",
)





@router.get("/check_token")
def check_token(credentials: HTTPAuthorizationCredentials = Security(security)):
    token = credentials.credentials
    try:
        payload = decode_jwt(token)
        return {"status": "valid", "user_id": payload.get("sub")}
    except HTTPException as e:
        return {"status": "invalid", "detail": e.detail}


# signin user
@router.post("/signin_user", response_model=User)
def signin_user(user: User, 
                user_db: Session = Depends(get_userdb)):
    check_user_id = get_user(user.user_id, user_db) # user가 table에 있는지 확인
    if check_user_id:
        raise HTTPException(status_code=409, detail="해당 아이디는 이미 존재합니다")
    
    check_user_user_name = user_db.query(User_model).filter(User_model.user_name == user.user_name).first()
    if check_user_user_name:
        raise HTTPException(status_code=409, detail="해당 닉네임은 이미 존재합니다")
    
    check_user_phone_number = user_db.query(User_model).filter(User_model.phone_number == user.phone_number).first()
    if check_user_phone_number:
        raise HTTPException(status_code=409, detail="해당 전화번호는 이미 존재합니다")
    
    check_user_student_address = user_db.query(User_model).filter(User_model.student_address == user.student_address).first()
    if check_user_student_address:
        raise HTTPException(status_code=409, detail="해당 학번은 이미 존재합니다")
    
    check_user_email = user_db.query(User_model).filter(User_model.email == user.email).first()
    if check_user_email:
        raise HTTPException(status_code=409, detail="해당 이메일은 이미 존재합니다")

    # db에 user를 추가
    create_user = User_model(user_id=user.user_id, 
                password=get_hash_password(user.password),
                user_name=user.user_name, 
                phone_number=user.phone_number,
                student_address=user.student_address,
                email = user.email,
                user_type = 1)

    user_db.add(create_user)
    user_db.commit()
    user_db.refresh(create_user)
    
    return create_user


# signin taxi
@router.post("/signin_taxi", response_model=Taxi)
def signin_user(user: Taxi, 
                user_db: Session = Depends(get_userdb),
                taxi_db: Session = Depends(get_taxidb)):
    check_user_id = get_user(user.user_id, user_db) # user가 table에 있는지 확인
    if check_user_id:
        raise HTTPException(status_code=409, detail="해당 아이디는 이미 존재합니다")
    
    check_user_user_name = user_db.query(User_model).filter(User_model.user_name == user.user_name).first()
    if check_user_user_name:
        raise HTTPException(status_code=409, detail="해당 닉네임은 이미 존재합니다")
    
    check_user_phone_number = user_db.query(User_model).filter(User_model.phone_number == user.phone_number).first()
    if check_user_phone_number:
        raise HTTPException(status_code=409, detail="해당 전화번호는 이미 존재합니다")
    
    check_taxi_car_number = taxi_db.query(Taxi_model).filter(Taxi_model.car_num == user.car_num).first()
    if check_taxi_car_number:
        raise HTTPException(status_code=409, detail="해당 차 번호는 이미 존재합니다")
    

    create_user = User_model(user_id=user.user_id, 
                password=get_hash_password(user.password),
                user_name=user.user_name, 
                phone_number=user.phone_number,
                student_address=f"택시기사{user.user_id}",
                email = f"택시기사{user.user_id}",
                user_type=0)
    
    create_taxi = Taxi_model(user_id = user.user_id,
                                driver_name = user.user_name,
                                car_num = user.car_num, 
                                car_model = user.car_model) 
            
    taxi_db.add(create_taxi)
    taxi_db.commit()
    taxi_db.refresh(create_taxi)
        
    user_db.add(create_user)
    user_db.commit()
    user_db.refresh(create_user)
    ret = Taxi(user_id=user.user_id, 
                password=get_hash_password(user.password),
                user_name=user.user_name, 
                phone_number=user.phone_number,
                car_num = user.car_num, 
                car_model = user.car_model,
                user_type=0
            )

    return ret
from models import Email_code as Email_code_model
from database import get_email_codedb

@router.post("/send_certification_number")
async def certification_number(email : certification_email,
                               user_db: Session = Depends(get_userdb),
                               email_db: Session = Depends(get_email_codedb)):
    try:
        number = send_message(email.email)
        check_user_id = user_db.query(User_model).filter(User_model.user_id == email.user_id).first()
        if check_user_id:
            raise HTTPException(status_code=400, detail="이미 아이디가 존재합니다.")
        check_user_email = user_db.query(User_model).filter(User_model.email == email.email).first()
        if check_user_email:
            raise HTTPException(status_code=400, detail="이미 이메일이 존재합니다.")

        db_email = Email_code_model(
            user_id=email.user_id,
            email=email.email,
            email_code=number
        )
        email_db.add(db_email)
        email_db.commit()
        email_db.refresh(db_email)

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"error : {e}")

    return number


# 이메일 인증
@router.post("/check_number")
async def check_certification_number(email : check_certification_email,
                                     email_db: Session = Depends(get_email_codedb)):
    try:
        chenck_number = email_db.query(Email_code_model).filter(Email_code_model.email == email.email).first()

        if email.number != chenck_number.email_code:
            raise HTTPException(status_code=400, detail="인증번호가 틀렸습니다.")
        
        user = email_db.query(Email_code_model).filter(Email_code_model.email == email.email)
        user.delete()
        email_db.commit()
        return {"message":"인증성공"}
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"error : {e}")


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
        user_type = check_user.user_type
    
        # 로그인에서 유저 타입 주는거 수정하기
        return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer", "user_type":user_type}


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


