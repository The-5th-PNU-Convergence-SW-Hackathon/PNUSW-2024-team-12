from pydantic import BaseModel
from datetime import datetime  

class HistoryCreate(BaseModel):
    date : datetime
    boarding_time: str
    quit_time: str
    amount: int
    depart: str
    dest: str
    mate: str

class HistoryResponse(BaseModel):
    user_id: str
    boarding_time: datetime
    quit_time: datetime
    amount: int
    depart: str
    dest: str
