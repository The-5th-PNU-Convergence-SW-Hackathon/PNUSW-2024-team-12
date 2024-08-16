from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os
load_dotenv()

DB_HOST = os.environ.get("DB_HOST")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
USER_DB_NAME = os.environ.get("USER_DB_NAME")
HISTORY_DB_NAME = os.environ.get("HISTORY_DB_NAME")
MATCH_DB_NAME = os.environ.get("MATCH_DB_NAME")
TAXI_DB_NAME = os.environ.get("TAXI_DB_NAME")
DB_PORT = os.environ.get("DB_PORT", 3306)

SQLALCHEMY_DATABASE_URL_USER = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{USER_DB_NAME}"
SQLALCHEMY_DATABASE_URL_HISTORY = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{HISTORY_DB_NAME}"
SQLALCHEMY_DATABASE_URL_MATCH = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{MATCH_DB_NAME}"
SQLALCHEMY_DATABASE_URL_TAXI = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{TAXI_DB_NAME}"

user_engine = create_engine(SQLALCHEMY_DATABASE_URL_USER)
history_engine = create_engine(SQLALCHEMY_DATABASE_URL_HISTORY)
match_engine = create_engine(SQLALCHEMY_DATABASE_URL_MATCH)
taxi_engine = create_engine(SQLALCHEMY_DATABASE_URL_TAXI)

user_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=user_engine)
history_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=history_engine)
match_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=match_engine)
taxi_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=taxi_engine)

user_Base = declarative_base()
history_Base = declarative_base()
match_Base = declarative_base()
taxi_Base = declarative_base()

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

def get_matchdb():
    db = match_SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_taxidb():
    db = taxi_SessionLocal()
    try:
        yield db
    finally:
        db.close()