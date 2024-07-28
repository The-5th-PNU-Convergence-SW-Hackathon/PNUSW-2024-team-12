from pydantic import BaseModel
# 입력받는 양식
class User(BaseModel):
    user_id: str
    password: str
    nickname: str
    user_type: bool

class Login_user(BaseModel):
    user_id: str
    password: str

class modify_password(BaseModel):
    user_id: str
    password: str
    new_password: str
 
