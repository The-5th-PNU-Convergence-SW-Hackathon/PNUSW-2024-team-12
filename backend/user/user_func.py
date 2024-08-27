# fastapi
from fastapi import HTTPException, Depends,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

# db
from sqlalchemy.orm import Session
from database import get_userdb
from models import User as User_model

# 비밀번호 해싱
from passlib.context import CryptContext
import jwt

# env
import os
from dotenv import load_dotenv
load_dotenv()

from typing import Optional
from datetime import datetime, timedelta

bcrypt_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
SECRET_KEY = os.environ.get("JWT_SECRET_KEY")
ALGORITHM = os.environ.get("ALGORITHM")
security = HTTPBearer()

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