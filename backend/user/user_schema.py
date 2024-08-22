from pydantic import BaseModel
from typing import Optional


# 입력받는 양식
class User(BaseModel):
    user_id: str
    password: str
    nickname: str
    phone_number: str
    student_address: str
    user_type: bool
    brr_cash : Optional[int]
    
class Taxi(User):
    # 택시 관련정보
    car_num : Optional[str]
    car_model : Optional[str]


    
class Login_user(BaseModel):
    user_id: str
    password: str

class modify_password(BaseModel):
    user_id: str
    password: str
    new_password: str
 
