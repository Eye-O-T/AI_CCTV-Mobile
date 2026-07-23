from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root():
    return {"셋팅 확인"}