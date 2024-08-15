from fastapi import HTTPException
import jwt
import os
from dotenv import load_dotenv
load_dotenv()
SECRET_KEY = os.environ.get("JWT_SECRET_KEY")
ALGORITHM = os.environ.get("ALGORITHM")


def decode_jwt(token: str):
    print("decode_jwt")
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        print(f"Decoded payload: {payload}")  
        return payload
    except jwt.ExpiredSignatureError:
        print("Token has expired")
        raise HTTPException(status_code=401, detail="토큰이 만료되었습니다.")
    except jwt.PyJWTError:
        print("Invalid token")  
        raise HTTPException(status_code=401, detail="인식되지 않는 토큰입니다.")