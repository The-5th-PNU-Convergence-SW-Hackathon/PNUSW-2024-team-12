from pydantic import BaseModel

class MatchingCreate(BaseModel):
    boarding_time: str
    depart: str
    dest: str
    max_mem: int