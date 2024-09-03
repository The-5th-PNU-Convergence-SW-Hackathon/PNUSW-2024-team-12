from pydantic import BaseModel

class TaxiResponse(BaseModel):
    taxi_id: int
    driver_name: str
    car_num: str
    phone_number: str
    depart: str
    dest: str
    path: str

# 택시한테 보낼 정보
class CallTaxi(BaseModel):
    id: int
    depart: str
    dest: str


# 택시가 호출을 받으면 사용자에게 보낼 정보
class CompletetCallTaxi(BaseModel):
    driver_name: str
    car_num: str
    phone_number: str


class CallInfo(BaseModel):
    id: int
    depart: str
    dest: str 
    taxi_fare : int
    distance: int
    duration: int
    





