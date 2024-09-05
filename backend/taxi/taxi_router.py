# fastapi
from fastapi import APIRouter, HTTPException, Depends, Security, WebSocket, WebSocketDisconnect
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

# db
from sqlalchemy.orm import Session
from database import get_matchdb, get_userdb, get_historydb, get_taxidb
from models import Matching as Matching_model, Lobby as Lobby_model, User as User_model, Taxi as Taxi_model
from taxi.taxi_schema import CallInfo, TaxiResponse, TaxiDriveComplete, TaxiMain
# user
from user.user_func import get_current_user

# history
from history.history_schema import HistoryCreate
from history.history_router import create_history

from datetime import datetime
from typing import List,Dict
import json


security = HTTPBearer()
router = APIRouter(
    prefix="/taxi"
)

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
async def websocket_endpoint(websocket: WebSocket, taxi_room_id: int, match_db: Session = Depends(get_matchdb)):
    await connection_manager.connect(taxi_room_id, websocket)
    try:
        # 클라이언트가 처음 연결되었을 때 현재 매칭 목록을 보내줍니다.
        matching_dicts = await calling_taxi(call_type=0, match_db=match_db)
        await connection_manager.broadcast(taxi_room_id=taxi_room_id, message=json.dumps(matching_dicts))
        
        while True:
            # 웹소켓을 통해서 클라이언트로부터 메시지를 받을 수 있음
            data = await websocket.receive_text()
            # 클라이언트로 받은 데이터를 다시 보내는 예시 (필요한 경우 추가 작업 수행 가능)
    except WebSocketDisconnect:
        connection_manager.disconnect(taxi_room_id, websocket)


# 택시들에게 리스트를 보여주는 함수
async def calling_taxi(call_type:int = None,
                       match_db: Session = None):
    print("calling_taxi success")
    if call_type == 1: # 콜을 잡고난 후 업데이트할 때
        matchings = match_db.query(Matching_model).filter(Matching_model.matching_taxi == 1).all()
    else: # 가장 처음 보일 때
        matchings = match_db.query(Matching_model).filter(Matching_model.matching_taxi == 1).all()
    

    matching_dicts = [
        {"id": m.id, "depart": m.depart, "dest": m.dest} for m in matchings
    ]
    print("matching_dicts : ", matching_dicts)
    # JSON으로 직렬화하여 웹소켓을 통해 방송합니다.
    await connection_manager.broadcast(taxi_room_id=0, message=json.dumps(matching_dicts))
    return matching_dicts


@router.get("/call_info", response_model=CallInfo)
async def call_info(
    matching_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb)
):
    if not matching_id:
        raise HTTPException(status_code=400, detail="매칭 아이디를 입력해야함")

    user = get_current_user(credentials, user_db)
    matching = match_db.query(Matching_model).filter(Matching_model.id == matching_id).first()

    if not matching:
        raise HTTPException(status_code=404, detail="매칭을 찾을 수 없음")

    call_info_data = CallInfo(
        id=matching.id,
        depart=matching.depart,
        dest=matching.dest,
        taxi_fare=matching.taxi_fare,
        distance=matching.distance,
        duration=matching.duration
    )

    return call_info_data

# 택시기사가 콜을 잡을 때
@router.post("/catch_call", response_model=TaxiResponse)
async def catch_call(
    matching_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    taxi_db: Session = Depends(get_taxidb),
    match_db: Session = Depends(get_matchdb)
):
    from matching.matching_router import lobby_manager

    if not matching_id:
        raise HTTPException(status_code=400, detail="매칭 아이디를 입력해야함")
    user = get_current_user(credentials, user_db)
    taxi = taxi_db.query(Taxi_model).filter(Taxi_model.driver_name == user.user_name).first()
    matching = match_db.query(Matching_model).filter(Matching_model.id == matching_id).first()
    if matching:
        matching.matching_taxi = 2
        match_db.commit()
    if not taxi:
        raise HTTPException(status_code=404, detail="택시를 찾을 수 없음")
    # 택시기사
    taxi_data = {
        "taxi_id" : user.id,
        "driver_name" : taxi.driver_name,
        "car_num" : taxi.car_num,
        "phone_number" : user.phone_number,
        "depart" : matching.depart,
        "dest" : matching.dest,
        "path" : matching.path
    }

    print(taxi_data)
    await lobby_manager.broadcast(matching_id, message=json.dumps(taxi_data))
    await calling_taxi(1, match_db)
    return taxi_data

# 운행이 완료된 상태
@router.post("/{matching_id}/complete", response_model=dict)
async def complete_drive(
    matching_id: int,
    amount: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb),
    history_db: Session = Depends(get_historydb),
    taxi_db: Session = Depends(get_taxidb)
):
    from matching.matching_router import lobby_manager
    user = get_current_user(credentials, user_db)
    
    # 매칭 정보 가져오기
    matching = match_db.query(Matching_model).filter(Matching_model.id == matching_id).first()
    if not matching:
        raise HTTPException(status_code=404, detail="매칭을 찾을 수 없음")

    lobbies = match_db.query(Lobby_model).filter(Lobby_model.matching_id == matching_id).all()
    if lobbies:
        raise HTTPException(status_code=400, detail="매칭에 연관된 대기실이 아직 존재합니다. 먼저 모든 대기실을 완료하세요.")

    # 현재 멤버 수가 최소 멤버 수 이상인지 확인
    if matching.current_member < matching.min_member:
        raise HTTPException(status_code=400, detail=f"최소 {matching.min_member}명의 인원이 필요합니다.")

    # matching_mate = [name.strip() for name in matching.mate.split(",")]
    # n_amount = amount / matching.current_member
    # for name in matching_mate:
    #     user_mate = user_db.query(User_model).filter(User_model.user_name == name).first()
    #     user_mate_brr_cash = user_mate.brr_cash
    #     user_mate.brr_cash =  user_mate_brr_cash - n_amount
    #     user_db.commit()


    taxi = taxi_db.query(Taxi_model).filter(Taxi_model.user_id == user.user_id).first()
    # taxi_user = user_db.query(User_model).filter(User_model.user_id == taxi.user_id).first()
    # if taxi_user:
    #     current_amout = taxi_user.brr_cash 
    #     taxi_user.brr_cash  = current_amout + amount
    #     user_db.commit()


    # history detail 추가하기 : 택시 데이터 추가
    history_data = HistoryCreate(
        car_num=taxi.car_num,
        date=datetime.now(), 
        boarding_time=matching.boarding_time.strftime("%H:%M"),  
        quit_time=datetime.now().strftime("%H:%M"),  
        amount=amount, 
        depart=matching.depart,
        dest=matching.dest,
        mate=matching.mate  
    )

    create_history(history=history_data, user_id=matching.created_by, db=history_db)

    # 매칭 삭제
    match_db.delete(matching)
    match_db.commit()
    await lobby_manager.broadcast(matching_id, message="운행완료")
    return {"message": "운행이 완료되어 매칭 정보가 기록되었습니다."}


# 택시기사가 매칭 id로 get을하면 
@router.get("/get_path")
def path(
    matching_id: int,
    match_db: Session = Depends(get_matchdb),
):
    matching = match_db.query(Matching_model).filter(Matching_model.id == matching_id).first()

    if not matching:
        raise HTTPException(status_code=400, detail="해당하는 매칭이 없습니다.")
    
    path = matching.path
    print(path)
    return path
    

@router.get("/taxi_main", response_model=TaxiMain)
def get_taxi_main(
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    taxi_db: Session = Depends(get_taxidb)
    ):

    user = get_current_user(credentials, user_db)
    
    taxi_data = taxi_db.query(Taxi_model).filter(Taxi_model.driver_name == user.user_name).first()

    return taxi_data

# @router.get("/complete/quit", response_model=TaxiDriveComplete)
# def get_taxi_complete(matching_id : int,
#                       car_num: str,

#                       ):

