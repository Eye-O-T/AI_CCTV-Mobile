from datetime import datetime

from fastapi import FastAPI, Depends, Query
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from sqlalchemy.orm import Session

from .database import engine, Base, get_db
from . import models, schemas
from .services.fcm_service import (
    initialize_firebase,
    send_event_notification,
    send_test_notification,
)


# 확인용 - 나중에 삭제해도 됨
print("models 위치:", models.__file__)
print("Event 존재:", hasattr(models, "Event"))


# DB 테이블 생성
Base.metadata.create_all(bind=engine)


# Firebase Admin SDK 초기화
initialize_firebase()


# FastAPI 애플리케이션 생성
app = FastAPI()


# /media로 요청하면 실제 media 폴더에서 파일을 찾아서 반환
app.mount(
    "/media",
    StaticFiles(directory="media"),
    name="media",
)


# FCM 테스트 요청 데이터
class FcmTestRequest(BaseModel):
    token: str


@app.get("/")
def root():
    return {"message": "CCTV API Server"}


# FCM 테스트용
@app.post("/test-notification")
def test_notification(request: FcmTestRequest):
    message_id = send_test_notification(request.token)

    return {
        "message": "FCM 전송 성공",
        "message_id": message_id,
    }


@app.post("/device-tokens")
def register_device_token(
    device_token: schemas.DeviceTokenCreate,
    db: Session = Depends(get_db),
):
    db_token = (
        db.query(models.DeviceToken)
        .filter(models.DeviceToken.token == device_token.token)
        .one_or_none()
    )

    if db_token is None:
        db_token = models.DeviceToken(
            token=device_token.token,
            platform=device_token.platform,
        )
        db.add(db_token)
    else:
        db_token.platform = device_token.platform

    db.commit()
    db.refresh(db_token)

    return {
        "id": db_token.id,
        "token": db_token.token,
        "platform": db_token.platform,
    }


@app.post("/events")
def create_event(
    event: schemas.EventCreate,
    db: Session = Depends(get_db),
):
    db_event = models.Event(
        camera_id=event.camera_id,
        occurred_at=event.occurred_at,
        gender=event.gender,
        age=event.age,
        appearance=event.appearance,
        crop_image_path=event.crop_image_path,
        trajectory_image_path=event.trajectory_image_path,
        clip_video_path=event.clip_video_path,
    )

    db.add(db_event)
    db.commit()
    db.refresh(db_event)

    tokens = [
        row.token
        for row in db.query(models.DeviceToken).all()
    ]

    try:
        notification = send_event_notification(tokens, db_event)
    except Exception as error:
        notification = {
            "success_count": 0,
            "failure_count": len(tokens),
            "invalid_tokens": [],
            "error": str(error),
        }

    if notification["invalid_tokens"]:
        (
            db.query(models.DeviceToken)
            .filter(models.DeviceToken.token.in_(notification["invalid_tokens"]))
            .delete(synchronize_session=False)
        )
        db.commit()

    return {
        "event": db_event,
        "notification": notification,
    }


@app.get("/events")
def get_events(
    from_: datetime | None = Query(default=None, alias="from"),
    to: datetime | None = None,
    db: Session = Depends(get_db),
):
    query = db.query(models.Event)

    if from_ is not None:
        query = query.filter(
            models.Event.occurred_at >= from_
        )

    if to is not None:
        query = query.filter(
            models.Event.occurred_at < to
        )

    events = (
        query
        .order_by(models.Event.occurred_at.desc())
        .all()
    )

    return events
