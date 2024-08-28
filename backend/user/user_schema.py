from pydantic import BaseModel
from typing import Optional


# 입력받는 양식
class User(BaseModel):
    user_id: str # 아이디
    password: str # 비밀번호
    user_name: str # 실제 이름 
    phone_number: str # 전화번호
    student_address: str # 학번
    email: str # 부산대 이메일 
    brr_cash : Optional[int]
    user_type: bool # 1
    
class Taxi(BaseModel):
    # 택시 관련정보
    user_id: str # 아이디
    password: str # 비밀번호
    user_name: str # 택시기사 이름
    phone_number: str # 전화번호
    car_num : Optional[str] # 차 번호
    car_model : Optional[str] # 차 모델
    user_type: bool # 0

class TokenRefreshRequest(BaseModel):
    refresh_token: str
    
class Login_user(BaseModel):
    user_id: str
    password: str

class modify_password(BaseModel):
    user_id: str
    password: str
    new_password: str
 
class certification_email(BaseModel):
    user_id: str
    email: str

class check_certification_email(BaseModel):
    user_id: str
    email: str
    number: str