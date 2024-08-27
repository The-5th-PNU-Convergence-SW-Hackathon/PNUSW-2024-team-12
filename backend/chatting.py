from fastapi import APIRouter,  WebSocket, WebSocketDisconnect
from fastapi.security import HTTPBearer
from typing import List,Dict
security = HTTPBearer()
router = APIRouter(
    prefix="/chat"
)


# 택시에게 호출보내기
class ChattingManager:
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
                await connection.send_text(message)

            

chatting_manager = ChattingManager()

@router.websocket("/{taxi_room_id}/ws")
async def websocket_endpoint(websocket: WebSocket, taxi_room_id: int):
    await chatting_manager.connect(taxi_room_id, websocket)
    try:
        while True:
            # 입력한 정보
            data = await websocket.receive_text()
            await chatting_manager.broadcast(taxi_room_id, data)
    except WebSocketDisconnect:
        chatting_manager.disconnect(taxi_room_id, websocket)


