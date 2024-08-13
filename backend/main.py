from fastapi import FastAPI
from user.user_router import router as user_router # user router 불러오기
from history.history_router import router as history_router # history router 불러오기
from fastapi.middleware.cors import CORSMiddleware
from database import user_engine,history_engine,user_Base,history_Base
app = FastAPI()


@app.get("/")
async def init():
    return {"init"}

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
user_Base.metadata.create_all(bind=user_engine)
history_Base.metadata.create_all(bind=history_engine)
# router 불러오기
app.include_router(user_router, tags=["user"])
app.include_router(history_router)
