from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Float, Boolean
from sqlalchemy.orm import relationship
from database import user_Base,history_Base,match_Base
from datetime import datetime

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

    lobby_user = relationship("LobbyUser", back_populates="user", uselist=False)
    created_lobbies = relationship("Lobby", back_populates="creator")


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
    max_member = Column(Integer, nullable=False)
    current_member = Column(Integer, nullable=False)

    lobby = relationship("Lobby", back_populates="matching", uselist=False)

class Lobby(match_Base):
    __tablename__ = "lobbies"
    id = Column(Integer, primary_key=True, index=True)
    depart = Column(Text, nullable=False)
    dest = Column(Text, nullable=False)
    max_member = Column(Integer, nullable=False)
    current_member = Column(Integer, nullable=False, default=0)
    created_by = Column(Integer, ForeignKey('user_info.user_id'), nullable=False)  # 방을 만든 사람의 ID

    matching_id = Column(Integer, ForeignKey('matching.id'))
    matching = relationship("Matching", back_populates="lobby")

    users = relationship("LobbyUser", back_populates="lobby")
    creator = relationship("User", back_populates="created_lobbies")

class LobbyUser(match_Base):
    __tablename__ = "lobby_users"
    id = Column(Integer, primary_key=True, index=True)
    lobby_id = Column(Integer, ForeignKey('lobbies.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('user_info.user_id'), nullable=False)
    joined_at = Column(DateTime, default=datetime.utcnow)

    lobby = relationship("Lobby", back_populates="users")
    user = relationship("User", back_populates="lobby_user")






    
