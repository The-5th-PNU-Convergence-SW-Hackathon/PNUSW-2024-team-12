

from fastapi import FastAPI, APIRouter, HTTPException, Depends
from pydantic import BaseModel
from fastapi.responses import JSONResponse

from database import user_Base, get_userdb, user_engine

from sqlalchemy.orm import Session
from database import get_userdb
from models import User as User_model
import uvicorn


# 비밀번호 해싱
from passlib.context import CryptContext
from user.user_schema import User, Login_user

bcrypt_context = CryptContext(schemes=['bcrypt'], deprecated='auto')


router = APIRouter(
    prefix="/history",
)




# signin user : 회원가입
@router.get("/history_")
def history():
    return {"good work"}
