from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, declarative_base

from dotenv import load_dotenv
import os
load_dotenv()
# dotenv로 수정하기
DB_PASSWORD = os.environ.get("DB_PASSWORD")
USER_DB_NAME = os.environ.get("USER_DB_NAME")
HISTORY_DB_NAME = os.environ.get("HISTORY_DB_NAME")
SQLALCHEMY_DATABASE_URL_USER = f"mysql+mysqlconnector://root:{DB_PASSWORD}@localhost:3306/{USER_DB_NAME}"
SQLALCHEMY_DATABASE_URL_HISTORY = f"mysql+mysqlconnector://root:{DB_PASSWORD}@localhost:3306/{HISTORY_DB_NAME}"

user_engine = create_engine(SQLALCHEMY_DATABASE_URL_USER)
history_engine = create_engine(SQLALCHEMY_DATABASE_URL_HISTORY)

user_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=user_engine)
history_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=history_engine)

user_Base = declarative_base()
history_Base = declarative_base()

def get_userdb():
    db = user_SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_historydb():
    db = history_SessionLocal()
    try:
        yield db
    finally:
        db.close()

