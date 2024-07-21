# todo 

# 토근 발급
# 회원정보 수정, 삭제
# history

from fastapi import FastAPI
from user.user_router import router as user_router # user router 불러오기
from history.history_router import router as history_router # history router 불러오기

import uvicorn
app = FastAPI()


@app.get("/")
async def init():
    return {"init"}


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", reload=True)


# router 불러오기
app.include_router(user_router)
app.include_router(history_router)
