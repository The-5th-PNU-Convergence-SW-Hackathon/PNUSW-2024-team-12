from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from database import user_Base, history_Base, match_Base, taxi_Base
from datetime import datetime


# User 모델 정의
class User(user_Base):
    __tablename__ = "user_info"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)  
    password = Column(String(255), nullable=False)
    user_name = Column(String(30), nullable=False)
    phone_number = Column(String(30), unique=True, nullable=False)
    student_address = Column(String(30), unique=True, nullable=False)
    email = Column(String(50), unique=True, nullable=False)
    user_type = Column(Boolean, nullable=False)
    brr_cash = Column(Integer, default=0)

# 다른 모델 정의
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


class Matching(match_Base):
    __tablename__ = "matching"
    id = Column(Integer, primary_key=True, index=True)
    matching_type = Column(Integer, index=True)
    boarding_time = Column(DateTime, nullable=False)
    depart = Column(Text, nullable=False)
    dest = Column(Text, nullable=False)
    min_member = Column(Integer, nullable=False)
    current_member = Column(Integer, nullable=False)
    created_by = Column(String(255), nullable=False)  
    mate = Column(String(50), nullable=False)  
    matching_taxi = Column(Integer, nullable=False)  # 0 : 택시가 잡을 수 없는 상태 / 1: 택시가 잡을 수 있는 상태 / 2 : 택시를 잡은 상태
    taxi_fare = Column(Integer)
    duration = Column(Integer)
    distance = Column(Integer)
    path = Column(Text)
    lobby = relationship("Lobby", back_populates="matching")


class Lobby(match_Base):
    __tablename__ = "lobbies"
    id = Column(Integer, primary_key=True, index=True)
    depart = Column(Text, nullable=False)
    dest = Column(Text, nullable=False)
    boarding_time = Column(DateTime, nullable=False)
    min_member = Column(Integer, nullable=False)
    current_member = Column(Integer, nullable=False, default=0)
    created_by = Column(String(255), nullable=False)  

    matching_id = Column(Integer, ForeignKey('matching.id'), nullable=False)
    matching = relationship("Matching", back_populates="lobby")

    users = relationship("LobbyUser", back_populates="lobby")


class LobbyUser(match_Base):
    __tablename__ = "lobby_users"
    id = Column(Integer, primary_key=True, index=True)
    lobby_id = Column(Integer, ForeignKey('lobbies.id'), nullable=False)
    user_id = Column(String(255), nullable=False)  
    joined_at = Column(DateTime, default=datetime.utcnow)

    lobby = relationship("Lobby", back_populates="users")

class Taxi(taxi_Base):
    __tablename__ = "taxes"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True) 
    driver_name = Column(String(30), nullable=False)
    car_num = Column(String(30), unique=True, nullable=False)
    car_model = Column(String(55), nullable=False)

class Email_code(user_Base):
    __tablename__ = "email_codes"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True) 
    email = Column(String(50), unique=True, nullable=False)
    email_code = Column(String(7), nullable=True)