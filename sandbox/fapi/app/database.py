from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker


# SQLite DB 파일 위치
DATABASE_URL = "sqlite:///./events.db"


# SQLAlchemy가 SQLite와 통신하기 위한 Engine
engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}
)


# DB 작업을 위한 Session 생성기
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)


# 앞으로 만들 SQLAlchemy 모델들의 부모 클래스
Base = declarative_base()

# FastAPI 요청이 들어올 때 DB 세션을 제공하는 함수
def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()