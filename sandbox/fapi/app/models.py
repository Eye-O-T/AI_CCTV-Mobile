from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime
from .database import Base


class Event(Base):
    __tablename__ = "events"

    # 이벤트 고유 번호
    id = Column(Integer, primary_key=True, index=True)

    # CCTV 및 이벤트 분석 정보
    camera_id = Column(String, nullable=False)
    occurred_at = Column(DateTime, nullable=False)
    gender = Column(String, nullable=False)
    age = Column(String, nullable=False)
    appearance = Column(String, nullable=False)

    # 이미지 / 영상은 DB에 넣지 않고 파일 경로만 저장
    crop_image_path = Column(String, nullable=False)
    trajectory_image_path = Column(String, nullable=False)
    clip_video_path = Column(String, nullable=False)


class DeviceToken(Base):
    __tablename__ = "device_tokens"

    id = Column(Integer, primary_key=True, index=True)
    token = Column(String, nullable=False, unique=True, index=True)
    platform = Column(String, nullable=True)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
    )
