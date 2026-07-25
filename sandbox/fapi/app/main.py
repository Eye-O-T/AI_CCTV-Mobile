from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root():
    return {"message": "실행 테스트"}