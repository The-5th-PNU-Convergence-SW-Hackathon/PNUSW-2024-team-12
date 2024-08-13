

from fastapi import APIRouter, HTTPException, Depends,Security
from typing import List
from database import get_historydb

from sqlalchemy.orm import Session
from database import get_historydb
from models import History as History_model
from history.history_schema import HistoryCreate, HistoryResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
import os
from dotenv import load_dotenv
load_dotenv()
SECRET_KEY = os.environ.get("JWT_SECRET_KEY")
ALGORITHM = os.environ.get("ALGORITHM")
security = HTTPBearer()
router = APIRouter(
    prefix="/history",
)
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
    

@router.post("/", response_model=HistoryResponse, tags=["history"])
def create_post(history: HistoryCreate,credentials: HTTPAuthorizationCredentials = Security(security), db: Session = Depends(get_historydb)):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")
    db_history = History_model(user_id= user_id, boarding_time=history.boarding_time, quit_time = history.quit_time,
                      amount=history.amount,depart=history.depart,dest=history.dest)
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

@router.get("/load", response_model=List[HistoryResponse], tags=["history"])
def read_notice(user_id: str, db: Session = Depends(get_historydb)):
    db_history = db.query(History_model).filter(History_model.user_id == user_id).all()
    if db_history is None:
        raise HTTPException(status_code=404, detail="내역을 찾을 수 없음")
    return db_history