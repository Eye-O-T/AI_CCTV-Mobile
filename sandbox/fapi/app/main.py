from datetime import datetime

from fastapi import FastAPI, Depends, Query
from fastapi.staticfiles import StaticFiles
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

# /media로 요청하면 실제 media 폴더에서 파일을 찾아서 반환
app.mount(
    "/media",
    StaticFiles(directory="media"),
    name="media"
)


@app.get("/")
def root():
    return {"message": "CCTV API Server"}


@app.post("/events")
def create_event(
    event: schemas.EventCreate,
    db: Session = Depends(get_db)
):
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

    db.add(db_event)
    db.commit()
    db.refresh(db_event)

    return db_event


@app.get("/events")
def get_events(
    from_: datetime | None = Query(default=None, alias="from"),
    to: datetime | None = None,
    db: Session = Depends(get_db)
):
    query = db.query(models.Event)

    if from_ is not None:
        query = query.filter(models.Event.occurred_at >= from_)

    if to is not None:
        query = query.filter(models.Event.occurred_at < to)

    events = query.order_by(models.Event.occurred_at.desc()).all()

    return events