from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Float, Boolean
from sqlalchemy.orm import relationship
from database import user_Base,history_Base

# DB에 저장하는 양식
class User(user_Base):
    __tablename__ = "user_info"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)
    password = Column(String(255), nullable=False)
    nickname = Column(String(30), unique=True, nullable=False)
    phone_number = Column(String(30), unique=True, nullable=False)
    student_address = Column(String(30), unique=True, nullable=False)
    user_type = Column(Boolean, nullable=False)

# class Taxi(User):
#     __tablename__ = "taxi"

#     taxi_id = Column(Integer, nullable=False)

class History(history_Base):
    __tablename__ = "history"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), index=True)
    car_num = Column(String(30))
    date = Column(DateTime)
    boarding_time = Column(String(6))
    quit_time = Column(String(6))
    amount = Column(Integer)
    depart = Column(String(50))
    dest = Column(String(50))
    mate = Column(String(80))


#     # user_key = Column(Integer, ForeignKey("users.id"))


class Matching():
    __tablename__ = "matching"

    matching_id = Column(Integer, primary_key=True, index=True)
    boarding_time = Column(DateTime, nullable=False) # 탑승시간
    depart = Column(Text, nullable=False) # 탑승장소
    dest = Column(Text, nullable=False) # 하차장소
    member = Column(Integer, nullable=False)
    
