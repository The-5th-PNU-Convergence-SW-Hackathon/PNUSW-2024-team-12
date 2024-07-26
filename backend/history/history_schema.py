from pydantic import BaseModel
import datetime

class HistoryCreate(BaseModel):
    boarding_time: datetime
    quit_time: datetime
    amount: int
    depart: str
    dest: str