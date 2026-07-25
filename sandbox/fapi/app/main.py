from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

from .database import engine, Base, get_db
from . import models, schemas


# 확인용 - 나중에 삭제해도 됨
print("models 위치:", models.__file__)
print("Event 존재:", hasattr(models, "Event"))


# DB 테이블 생성
Base.metadata.create_all(bind=engine)


# FastAPI 애플리케이션 생성
app = FastAPI()


@app.get("/")
def root():
    return {"message": "CCTV API Server"}


@app.post("/events")
def create_event(
    event: schemas.EventCreate,
    db: Session = Depends(get_db)
):
    # Pydantic 객체 → SQLAlchemy 객체
    db_event = models.Event(
        camera_id=event.camera_id,
        occurred_at=event.occurred_at,
        gender=event.gender,
        age=event.age,
        appearance=event.appearance,
        crop_image_path=event.crop_image_path,
        trajectory_image_path=event.trajectory_image_path,
        clip_video_path=event.clip_video_path
    )

    # DB에 저장
    db.add(db_event)
    db.commit()
    db.refresh(db_event)

    return db_event

@app.get("/events")
def get_events(db: Session = Depends(get_db)):
    # events 테이블의 모든 데이터를 조회
    events = db.query(models.Event).all()

    return events