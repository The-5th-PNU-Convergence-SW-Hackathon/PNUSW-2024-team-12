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
    id: str
    user_id: str
    car_num: str
    date: datetime
    boarding_time: str
    quit_time: str
    amount: int
    depart: str
    dest: str
