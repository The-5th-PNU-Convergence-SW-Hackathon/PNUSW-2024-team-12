from fastapi import APIRouter, HTTPException, Depends, Security, WebSocket, WebSocketDisconnect
from database import get_matchdb, get_userdb, get_historydb
from sqlalchemy.orm import Session
from models import Matching as MatchingModel, Lobby as LobbyModel, LobbyUser as LobbyUserModel, User as UserModel
from matching.matching_schema import MatchingCreate, MatchingResponse, LobbyResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from matching.matching_crud import decode_jwt
from taxi.taxi_schema import CallTaxi
from datetime import datetime
from typing import List,Dict
import json
security = HTTPBearer()
router = APIRouter(
    prefix="/taxi"
)

def get_current_user(credentials: HTTPAuthorizationCredentials, db: Session):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")

    user = db.query(UserModel).filter(UserModel.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# # 택시기사님들에게 호출 정보를 보여줌
# @router.get("/calling")
# def get_calling(
#     matching_id: int,
#     credentials: HTTPAuthorizationCredentials = Security(security),
#     user_db: Session = Depends(get_userdb),
#     match_db: Session = Depends(get_matchdb)
# ):
#     user = get_current_user(credentials, user_db)

#     matchings = match_db.query(MatchingModel).all()
#     matching =  [{"id": m.id, "depart": m.depart, "dest": m.dest} for m in matchings]
#     if not matching:
#         raise HTTPException(status_code=404, detail="해당 아이디의 매칭 목록이 없음")
#     return matching

# 매칭 번호에 해당하는 정보들을 택시기사들한테 보내줌 : 매칭번호, 출발지, 목적지


# lobby complete 될 때 같이 택시를 호출하면 됨


# 택시에게 호출보내기
class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

connection_manager = ConnectionManager()

@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await connection_manager.connect(websocket)
    try:
        while True:
            # 웹소켓을 통해서 클라이언트로부터 메시지를 받을 수 있음
            data = await websocket.receive_text()
            # 클라이언트로 받은 데이터를 다시 보내는 예시
            await connection_manager.send_personal_message(f"You wrote: {data}", websocket)
    except WebSocketDisconnect:
        connection_manager.disconnect(websocket)

@router.websocket("/taxiResponse/ws")
async def taxi_response_endpoint(websocket: WebSocket):
    await connection_manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            # 받아온 데이터를 바탕으로 post보냄(택시 정보를 함께 보냄) -> 유저한테 데이터 보내기
            print(f"Response received: {data}")
            # 여기서 추가적인 서버 측 처리 (예: 데이터베이스 업데이트 등)을 수행할 수 있습니다.
    except WebSocketDisconnect:
        connection_manager.disconnect(websocket)


async def calling_taxi(matchings):
    # 데이터 줄 때 유저를 확인할 수 있는 정보 추가로 넘기기 ex) user_id or nickname(현재 매칭 테이블에는 방장의 user_id가 없음)
    matching_dicts = [
        {"id": m.id, "depart": m.depart, "dest": m.dest} for m in matchings
    ]
    
    # JSON으로 직렬화하여 웹소켓을 통해 방송합니다.
    await connection_manager.broadcast(message=json.dumps(matching_dicts))
    return matching_dicts
