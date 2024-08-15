from fastapi import APIRouter, HTTPException, Depends,Security
from typing import List
from database import get_matchdb
from sqlalchemy.orm import Session
from models import Matching as Matching_model
# from matching.matching_schema import HistoryCreate, HistoryResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
import os
from dotenv import load_dotenv
load_dotenv()

router = APIRouter(
    prefix="/matching",
)