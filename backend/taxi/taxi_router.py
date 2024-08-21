from fastapi import APIRouter, HTTPException, Depends, Security, WebSocket, WebSocketDisconnect
from database import get_matchdb, get_userdb, get_historydb, get_taxidb
from sqlalchemy.orm import Session
from models import Matching as MatchingModel, Lobby as LobbyModel, LobbyUser as LobbyUserModel, User as UserModel, Taxi as TaxiModel
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from matching.matching_crud import decode_jwt
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



# 택시들이 손님들의 리스트를 보는곳은 0번방
# 손님이 택시 호출을 하면 0번방의 리스트에 도착지, 출발지 등의 정보가 추가됨
# 택시기사가 손님을 선택하면 matching_id로 방 번호가 생성됨
# 손님들은 방 번호로 이동 /taxi/{taxi_room_id}/ws
# 해당 방에 택시 기사의 정보가 보여짐

# 중요 : 프론트엔드에서는 matchin_id에 해당하는 웹 소켓 주소를 열어줘야함(손님들에게)

# 택시에게 호출보내기
class ConnectionManager:
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

            

connection_manager = ConnectionManager()

@router.websocket("/{taxi_room_id}/ws")
async def websocket_endpoint(websocket: WebSocket, taxi_room_id: int):
    await connection_manager.connect(taxi_room_id, websocket)
    try:
        while True:
            # 웹소켓을 통해서 클라이언트로부터 메시지를 받을 수 있음
            data = await websocket.receive_text()
            # 클라이언트로 받은 데이터를 다시 보내는 예시
    except WebSocketDisconnect:
        connection_manager.disconnect(taxi_room_id, websocket)


# 택시들에게 리스트를 보여주는 함수
async def calling_taxi(call_type:int = None,
                       match_db: Session = None):
    print("calling_taxi success")
    if call_type == 1:
        matchings = match_db.query(MatchingModel).filter(MatchingModel.matching_taxi == None).all()
    else:
        matchings = match_db.query(MatchingModel).all()
    

    matching_dicts = [
        {"id": m.id, "depart": m.depart, "dest": m.dest} for m in matchings
    ]
    print("matching_dicts : ", matching_dicts)
    # JSON으로 직렬화하여 웹소켓을 통해 방송합니다.
    await connection_manager.broadcast(taxi_room_id=0, message=json.dumps(matching_dicts))
    return matching_dicts

# 택시기사가 콜을 잡을 때
@router.post("/catch_call")
async def catch_call(
    matching_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    taxi_db: Session = Depends(get_taxidb),
    match_db: Session = Depends(get_matchdb)
):
    if not matching_id:
        raise HTTPException(status_code=400, detail="matching_id is required")
    user = get_current_user(credentials, user_db)
    taxi = taxi_db.query(TaxiModel).filter(TaxiModel.driver_name == user.nickname).first()
    if not taxi:
        raise HTTPException(status_code=404, detail="택시를 찾을 수 없음")
    # 택시기사
    taxi_data = {
        "taxi_id" : user.id,
        "driver_name" : taxi.driver_name,
        "car_num" : taxi.car_num,
        "phone_number" : user.phone_number
    }

    # 매칭이 성사되었으니 0번방에 성사된 리스트를 제거해서 보여줌
    matching = match_db.query(MatchingModel).filter(MatchingModel.id == matching_id).first()
    if matching:
        matching.matching_taxi = 1
        match_db.commit()

    print(taxi_data)
    await connection_manager.broadcast(taxi_room_id=matching_id, message=json.dumps(taxi_data))
    await calling_taxi(1, match_db)
    return taxi_data
