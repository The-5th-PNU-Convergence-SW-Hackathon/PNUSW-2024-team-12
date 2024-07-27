

from fastapi import FastAPI, APIRouter, HTTPException, Depends
from fastapi.responses import JSONResponse
from typing import List
from database import history_Base, get_historydb, history_engine

from sqlalchemy.orm import Session
from database import get_historydb
from models import History as History
from history_schema import HistoryCreate, HistoryResponse

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

@router.post("/", response_model=HistoryResponse, tags=["history"])
def create_post(history: HistoryCreate, db: Session = Depends(get_historydb)):
    user_id = "11" #로직구현해야함
    db_history = History(user_id= user_id, boarding_time=history.boarding_time, quit_time = history.quit_time,
                      amount=history.amount,depart=history.depart,dest=history.dest)
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

@router.get("/load", response_model=List[HistoryResponse], tags=["history"])
def read_notice(user_id: str, db: Session = Depends(get_historydb)):
    db_history = db.query(History).filter(History.user_id == user_id).all()
    if db_history is None:
        raise HTTPException(status_code=404, detail="내역을 찾을 수 없음")
    return db_history