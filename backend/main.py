from fastapi import FastAPI, APIRouter, HTTPException, Depends
from pydantic import BaseModel
from fastapi.responses import JSONResponse

from database import user_Base, get_userdb, user_engine

from sqlalchemy.orm import Session
from database import get_userdb
from models import User as User_model
import uvicorn


# 비밀번호 해싱
from passlib.context import CryptContext

bcrypt_context = CryptContext(schemes=['bcrypt'], deprecated='auto')


app = FastAPI()
router = APIRouter()

# 입력받는 양식
class User(BaseModel):
    user_id: str
    password: str
    nickname: str
    user_type: bool

class Login_user(BaseModel):
    user_id: str
    password: str

# 모든 유저를 불러옴
def get_all_user(db: Session):
    return db.query(User_model).order_by(User_model.id.desc()).all() # model의 class를 들고와야함

# user_id가 일치한 값을 불러옴 
def get_user(user_id, db: Session):
    user = db.query(User_model).filter(User_model.user_id == user_id).first()
    if user:
        return user # -> check_user : id중복확인
    else:
        return None 


@app.get("/")
async def init():
    return {"init"}

# signin user : 회원가입
@app.post("/signin", response_model=User)
def signin_user(user: User, db: Session = Depends(get_userdb)):
    check_user = get_user(user.user_id, db) # user가 table에 있는지 확인
    print(check_user)
    if check_user:
        raise HTTPException(status_code=409, detail="해당 아이디는 이미 존재합니다")
    
    # db에 user를 추가
    create_user = User_model(user_id=user.user_id, 
                   password=bcrypt_context.hash(user.password),
                   nickname=user.nickname, 
                   user_type=user.user_type)
    db.add(create_user)
    db.commit()
    db.refresh(create_user)
    
    return create_user

# login : 로그인
@app.post("/login", response_model=User)
def login_user(user: Login_user, db: Session = Depends(get_userdb)):
    check_user = get_user(user.user_id, db)
    print(check_user)

    if not check_user:
        raise HTTPException(status_code=410, detail="존재하지 않는 ID입니다.")
    elif not bcrypt_context.verify(user.password, check_user.password):  # 비밀번호 검증
        raise HTTPException(status_code=410, detail="비밀번호가 틀렸습니다.")
    else:
        return check_user

# # modify user : 회원정보 수정
# @app.put("/modifyUser/{id}")
# def modify_user(user: Login_user, db: Session = Depends(get_userdb)):


# delete user : 회원정보 삭제
# @app.delete("/deleteUser/{id}")


# 모든 유저를 불러옴
@app.get("/users", response_class=JSONResponse)
def read_users(db: Session = Depends(get_userdb)):
    data = get_all_user(db)
    return data


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", reload=True)