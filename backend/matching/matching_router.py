from fastapi import APIRouter, HTTPException, Depends, Security, WebSocket, WebSocketDisconnect
from database import get_matchdb, get_userdb
from sqlalchemy.orm import Session
from models import Matching as MatchingModel, Lobby as LobbyModel, LobbyUser as LobbyUserModel, User as UserModel
from matching.matching_schema import MatchingCreate, MatchingResponse, LobbyResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from matching.matching_crud import decode_jwt
from datetime import datetime
from typing import List,Dict
from taxi.taxi_router import calling_taxi

security = HTTPBearer()
router = APIRouter(prefix="/matching")
active_connections = {}

def get_current_user(credentials: HTTPAuthorizationCredentials, db: Session):
    token = credentials.credentials
    payload = decode_jwt(token)
    user_id = payload.get("sub")

    user = db.query(UserModel).filter(UserModel.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
class LobbyManager:
    def __init__(self):
        self.active_connections: Dict[int, List[WebSocket]] = {}

    async def connect(self, lobby_id: int, websocket: WebSocket, match_db: Session):
        await websocket.accept()
        if lobby_id not in self.active_connections:
            self.active_connections[lobby_id] = []
        self.active_connections[lobby_id].append(websocket)
        lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
        if lobby:
            await self.broadcast(lobby_id, f"{lobby.current_member}")
        else:
            await websocket.send_text("로비를 찾을 수 없음")

    async def disconnect(self, lobby_id: int, websocket: WebSocket, match_db: Session):
        self.active_connections[lobby_id].remove(websocket)
        if not self.active_connections[lobby_id]:
            del self.active_connections[lobby_id]
        lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
        if lobby:
            await self.broadcast(lobby_id, f"{lobby.current_member}")
        else:
            print("로비를 찾을 수 없음")
    async def broadcast(self, lobby_id: int, message: str):
        if lobby_id in self.active_connections:
            for connection in self.active_connections[lobby_id]:
                await connection.send_text(message)
        else:
            print(f"No active connections for lobby_id {lobby_id}")

lobby_manager = LobbyManager()

# WebSocket 엔드포인트
@router.websocket("/lobbies/{lobby_id}/ws")
async def websocket_endpoint(websocket: WebSocket, lobby_id: int, match_db: Session = Depends(get_matchdb)):
    await lobby_manager.connect(lobby_id, websocket, match_db)
    try:
        while True:
            data = await websocket.receive_text()
            lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
            if lobby:
                await lobby_manager.broadcast(lobby_id, f"{lobby.current_member}")
            else:
                await websocket.send_text("로비를 찾을 수 없음")
    except WebSocketDisconnect:
        await lobby_manager.disconnect(lobby_id, websocket, match_db)
        lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
        if lobby:
            await lobby_manager.broadcast(lobby_id, f"{lobby.current_member}")



@router.post("/create", response_model=MatchingResponse)
def create_matching(
    matching: MatchingCreate,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb)
):
    user = get_current_user(credentials, user_db)

    db_matching = MatchingModel(
        matching_type=matching.matching_type,
        boarding_time=datetime.now(),
        depart=matching.depart,
        dest=matching.dest,
        min_member=matching.min_member,  
        current_member=1,
        created_by=user.user_id,  
        mate=str(user.user_id),
        matching_taxi=0
    )
    match_db.add(db_matching)
    match_db.commit()
    match_db.refresh(db_matching)

    # Lobby 생성
    db_lobby = LobbyModel(
        depart=matching.depart,
        dest=matching.dest,
        boarding_time=datetime.now(),  
        min_member=matching.min_member,  
        current_member=1,
        matching_id=db_matching.id,
        created_by=user.user_id  
    )
    match_db.add(db_lobby)
    match_db.commit()
    match_db.refresh(db_lobby)

    # 유저를 생성된 대기실에 추가
    lobby_user = LobbyUserModel(user_id=user.user_id, lobby_id=db_lobby.id)
    match_db.add(lobby_user)
    match_db.commit()
    match_db.refresh(lobby_user)

    return db_matching

@router.delete("/matchings/cancel", response_model=dict)
def cancel_matching(
    matching_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb)
):
    user = get_current_user(credentials, user_db)

    # 매칭 정보 가져오기
    matching = match_db.query(MatchingModel).filter(MatchingModel.id == matching_id).first()
    if not matching:
        raise HTTPException(status_code=404, detail="매칭을 찾을 수 없음")

    if matching.created_by != user.user_id:
        raise HTTPException(status_code=403, detail="오직 방 생성자만 매칭을 취소할 수 있습니다.")

    # 해당 매칭과 연관된 대기실과 유저들 모두 삭제
    lobbies = match_db.query(LobbyModel).filter(LobbyModel.matching_id == matching_id).all()
    for lobby in lobbies:
        match_db.query(LobbyUserModel).filter(LobbyUserModel.lobby_id == lobby.id).delete()
        match_db.delete(lobby)

    match_db.delete(matching)
    match_db.commit()

    return {"message": "매칭과 관련된 대기실 및 모든 유저가 정상적으로 삭제되었습니다."}

@router.post("/lobbies/join", response_model=LobbyResponse)
async def join_lobby(
    lobby_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb)
):
    user = get_current_user(credentials, user_db)

    # 이미 다른 대기실에 있는지 확인
    existing_lobby_user = match_db.query(LobbyUserModel).filter(LobbyUserModel.user_id == user.user_id).first()
    if existing_lobby_user is not None:
        raise HTTPException(status_code=400, detail="유저가 이미 다른 대기실에 존재합니다")

    # 대기실 정보 가져오기
    lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
    match = match_db.query(MatchingModel).filter(MatchingModel.id == lobby_id).first()
    if not lobby:
        raise HTTPException(status_code=404, detail="대기실을 찾을 수 없음")

    # 현재 멤버 수가 최대 멤버 수보다 많거나 같으면 입장 불가
    if lobby.current_member >= 4:
        raise HTTPException(status_code=400, detail="대기실이 인원이 가득 찼습니다.")

    lobby_user = LobbyUserModel(lobby_id=lobby_id, user_id=user.user_id)
    
    lobby.current_member += 1
    match.current_member += 1
    match_db.add(lobby_user)
    match_db.commit()
    match_db.refresh(lobby_user)

    match_db.refresh(lobby)

    # 연결된 WebSocket 클라이언트들에게 업데이트된 인원 수를 알림
    await lobby_manager.broadcast(lobby_id, f"{lobby.current_member}")

    return lobby


@router.post("/lobbies/leave", response_model=LobbyResponse)
async def leave_lobby(
    lobby_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb)
):
    user = get_current_user(credentials, user_db)

    lobby_user = match_db.query(LobbyUserModel).filter(LobbyUserModel.user_id == user.user_id, LobbyUserModel.lobby_id == lobby_id).first()
    if not lobby_user:
        raise HTTPException(status_code=404, detail="해당 유저는 대기실에 들어가 있지 않습니다.")

    lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
    match = match_db.query(MatchingModel).filter(MatchingModel.id == lobby_id).first()
    if not lobby:
        raise HTTPException(status_code=404, detail="대기실을 찾을 수 없음")

    # LobbyUser 삭제
    match_db.delete(lobby_user)
    lobby.current_member -= 1
    match.current_member -= 1
    match_db.commit()
    match_db.refresh(lobby)

    # 연결된 WebSocket 클라이언트들에게 업데이트된 인원 수를 알림
    await lobby_manager.broadcast(lobby_id, f"{lobby.current_member}")

    return lobby

@router.get("/lobbies/{matching_type}/", response_model=List[LobbyResponse])
def list_lobbies_by_matching_type(matching_type: int, match_db: Session = Depends(get_matchdb)):
    matchings = match_db.query(MatchingModel).filter(MatchingModel.matching_type == matching_type).all()

    if not matchings:
        raise HTTPException(status_code=404, detail="해당 매칭에 관련된 대기실이 존재하지 않습니다.")

    lobbies = []
    for matching in matchings:
        matching_lobbies = match_db.query(LobbyModel).filter(LobbyModel.matching_id == matching.id).all()
        for lobby in matching_lobbies:
            lobbies.append(LobbyResponse(
                id=lobby.id,
                depart=lobby.depart,
                dest=lobby.dest,
                min_member=lobby.min_member,
                current_member=lobby.current_member,
                boarding_time=lobby.boarding_time,
                created_by=lobby.created_by
            ))

    return lobbies


# 인원이 모이면 매칭을 완료
@router.post("/lobbies/{lobby_id}/complete", response_model=dict)
async def complete_lobby(
    lobby_id: int,
    credentials: HTTPAuthorizationCredentials = Security(security),
    user_db: Session = Depends(get_userdb),
    match_db: Session = Depends(get_matchdb)
):
    user = get_current_user(credentials, user_db)

    # 대기실 정보 가져오기
    lobby = match_db.query(LobbyModel).filter(LobbyModel.id == lobby_id).first()
    if not lobby:
        raise HTTPException(status_code=404, detail="대기실을 찾을 수 없음")

    if lobby.created_by != user.user_id:
        raise HTTPException(status_code=403, detail="오직 방 생성자만 매칭 완료를 실행할 수 있습니다.")

    # 현재 멤버 수가 최소 멤버 수 이상인지 확인
    if lobby.current_member < lobby.min_member:
        raise HTTPException(status_code=400, detail=f"최소 {lobby.min_member}명의 인원이 필요합니다.")

    lobby_users = match_db.query(LobbyUserModel).filter(LobbyUserModel.lobby_id == lobby_id).all()
    mate_ids = ",".join([str(user.user_id) for user in lobby_users])
    
    # 택시기사에게 매칭리스트 호출
    await calling_taxi(0, match_db) 

    matching = match_db.query(MatchingModel).filter(MatchingModel.id == lobby.matching_id).first()
    if matching:
        matching.mate = mate_ids
        match_db.commit()

    match_db.query(LobbyUserModel).filter(LobbyUserModel.lobby_id == lobby_id).delete()

    match_db.delete(lobby)
    match_db.commit()

    return {"message": "대기실이 정상적으로 완료되었습니다."}
