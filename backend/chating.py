from fastapi import APIRouter, HTTPException, Depends, Security, WebSocket, WebSocketDisconnect
from database import get_matchdb, get_userdb, get_historydb, get_taxidb
from sqlalchemy.orm import Session
from models import Matching as MatchingModel, Lobby as LobbyModel, LobbyUser as LobbyUserModel, User as UserModel, Taxi as TaxiModel
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from matching.matching_crud import decode_jwt
from typing import List,Dict
from history.history_schema import HistoryCreate
from history.history_router import create_history
from datetime import datetime
import json

router = APIRouter(
    prefix="/chat"
)


# 택시에게 호출보내기
class ChatingManager:
    def __init__(self):
        self.active_connections: Dict[int, List[WebSocket]] = {}

    async def connect(self, taxi_room_id, websocket: WebSocket):
        await websocket.accept()
        if taxi_room_id not in self.active_connections:
            self.active_connections[taxi_room_id] = []
        self.active_connections[taxi_room_id].append(websocket)

    def disconnect(self, taxi_room_id, websocket: WebSocket ):
        self.active_connections[taxi_room_id].remove(websocket)
        if not self.active_connections[taxi_room_id]:
            del self.active_connections[taxi_room_id]

    async def broadcast(self, taxi_room_id, message: str):
        if taxi_room_id in self.active_connections:
            for connection in self.active_connections[taxi_room_id]:
                print("메세지보냄")
                await connection.send_text(message)

            

chating_manager = ChatingManager()

@router.websocket("/{taxi_room_id}/ws")
async def websocket_endpoint(websocket: WebSocket, taxi_room_id: int):
    await chating_manager.connect(taxi_room_id, websocket)
    try:
        while True:
            # 웹소켓을 통해서 클라이언트로부터 메시지를 받을 수 있음
            data = await websocket.receive_text()
            # 클라이언트로 받은 데이터를 다시 보내는 예시
    except WebSocketDisconnect:
        chating_manager.disconnect(taxi_room_id, websocket)
