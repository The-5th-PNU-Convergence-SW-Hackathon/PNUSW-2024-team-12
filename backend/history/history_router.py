

from fastapi import APIRouter, HTTPException, Depends,Security
from typing import List
from database import get_historydb, get_taxidb
from sqlalchemy.orm import Session
from models import History as History_model, Taxi as Taxi_model
from history.history_schema import HistoryCreate, HistoryResponse, HistoryDetailResponse
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


# history detail 추가하기 : 택시 데이터 추가
@router.post("/", response_model=HistoryResponse)
def create_history(history: HistoryCreate, user_id: str, db: Session = Depends(get_historydb)):

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
    if not db_history:
        raise HTTPException(status_code=404, detail="이용내역을 추가할 수 없음")
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

@router.get("/load_info/{history_id}", response_model=HistoryDetailResponse)
def read_history_info(
    history_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security), 
    history_db: Session = Depends(get_historydb),
    taxi_db: Session = Depends(get_taxidb)
    ):


    history = history_db.query(History_model).filter(History_model.id == history_id).first()
    if not history:
        raise HTTPException(status_code=404, detail="히스토리 내역이 없습니다.")
    
    
    history_car_num = history.car_num
    history_taxi = taxi_db.query(Taxi_model).filter(Taxi_model.car_num == history_car_num).first()
    if not history_taxi:
        raise HTTPException(status_code=404, detail=f"{history_car_num}에 해당하는 차량이 없습니다.")
    
    history_detail = HistoryDetailResponse(
        id=history.id,
        car_num=history_taxi.car_num,
        car_model=history_taxi.car_model,
        driver_name=history_taxi.driver_name,
        date=history.date,
        boarding_time= history.boarding_time,
        quit_time= history.quit_time,
        depart=history.depart,
        dest=history.dest,
        amount=history.amount,
        mate=history.mate
    )


    return history_detail