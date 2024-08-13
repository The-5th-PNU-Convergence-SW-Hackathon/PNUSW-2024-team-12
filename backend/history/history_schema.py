from pydantic import BaseModel
from datetime import datetime  

class HistoryCreate(BaseModel):
    boarding_time: datetime 
    quit_time: datetime
    amount: int
    depart: str
    dest: str

class HistoryResponse(BaseModel):
    user_id: str
    boarding_time: datetime
    quit_time: datetime
    amount: int
    depart: str
    dest: str
