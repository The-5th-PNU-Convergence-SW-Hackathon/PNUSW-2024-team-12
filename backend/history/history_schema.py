from pydantic import BaseModel
from datetime import datetime  

class HistoryCreate(BaseModel):
    car_num : str
    date : datetime
    boarding_time: str
    quit_time: str
    amount: int
    depart: str
    dest: str
    mate: str

class HistoryResponse(BaseModel):
    id: int
    user_id: str
    car_num: str
    date: datetime
    boarding_time: str
    quit_time: str
    amount: int
    depart: str
    dest: str

class HistoryDetailResponse(BaseModel):
    id: int
    car_num: str
    car_model: str
    driver_name: str
    date: datetime
    boarding_time: str
    quit_time: str
    depart: str
    dest: str
    amount: int
    mate: str