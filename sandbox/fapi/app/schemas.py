from datetime import datetime
from pydantic import BaseModel


# POST /events 요청으로 받을 데이터 형식
class EventCreate(BaseModel):
    camera_id: str
    occurred_at: datetime
    gender: str
    age: str
    appearance: str
    crop_image_path: str
    trajectory_image_path: str
    clip_video_path: str


class DeviceTokenCreate(BaseModel):
    token: str
    platform: str | None = None
