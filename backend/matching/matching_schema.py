from pydantic import BaseModel
from typing import List
from datetime import datetime

class MatchingCreate(BaseModel):
    matching_type: int
    depart: str
    dest: str
    min_member: int
    taxi_fare: int
    duration: int
    distance: int
    path: str

class MatchingResponse(BaseModel):
    id: int
    matching_type: int
    boarding_time: datetime
    depart: str
    dest: str
    min_member: int
    current_member: int
    taxi_fare: int
    duration: int
    distance: int

    class Config:
        orm_mode = True

class LobbyResponse(BaseModel):
    id: int
    depart: str
    dest: str
    min_member: int
    current_member: int
    boarding_time: datetime
    created_by: str  # 방을 만든 사람의 ID

    class Config:
        orm_mode = True


class LobbyListResponse(BaseModel):
    lobbies: List[LobbyResponse]

    class Config:
        orm_mode = True
    
class MatchingDo(BaseModel):
    id : int

    class Config:
        orm_mode = True