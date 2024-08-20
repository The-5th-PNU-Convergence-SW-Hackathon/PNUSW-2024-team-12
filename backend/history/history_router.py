

from fastapi import APIRouter, HTTPException, Depends,Security
from typing import List
from database import get_historydb
from sqlalchemy.orm import Session
from models import History as History_model
from history.history_schema import HistoryCreate, HistoryResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from history.history_crud import decode_jwt
from sqlalchemy import or_
from datetime import datetime, timedelta
security = HTTPBearer()
router = APIRouter(
    prefix="/history",
)
    

@router.delete("/cleanup", response_model=List[HistoryResponse])
def cleanup_old_history(db: Session = Depends(get_historydb)):
    threshold_date = datetime.utcnow() - timedelta(days=30)

    old_records = db.query(History_model).filter(History_model.date < threshold_date).all()

    for record in old_records:
        db.delete(record)
    
    db.commit()

    return old_records

@router.post("/", response_model=HistoryResponse)
def create_history(history: HistoryCreate, credentials: HTTPAuthorizationCredentials = Security(security), db: Session = Depends(get_historydb)):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")
    db_history = History_model(
        user_id=user_id, 
        car_num=history.car_num, 
        date=history.date, 
        boarding_time=history.boarding_time, 
        quit_time=history.quit_time,
        amount=history.amount,
        depart=history.depart,
        dest=history.dest,
        mate=history.mate
    )
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

@router.get("/load", response_model=List[HistoryResponse])
def read_history(credentials: HTTPAuthorizationCredentials = Security(security), db: Session = Depends(get_historydb)):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")


    search_pattern = f"%{user_id}%"  
    cleanup_old_history(db)

    db_history = db.query(History_model).filter(
        or_(
            History_model.user_id == user_id,
            History_model.mate.like(search_pattern) 
        )
    ).all()

    if not db_history:
        raise HTTPException(status_code=404, detail="내역을 찾을 수 없음")
    
    return db_history

@router.get("/load_info/{history.id}")
def read_history_info(credentials: HTTPAuthorizationCredentials = Security(security), db: Session = Depends(get_historydb)):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")