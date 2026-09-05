import os
from pathlib import Path

import firebase_admin
from firebase_admin import credentials, messaging


def initialize_firebase():
    if not firebase_admin._apps:
        credential_path = _find_credential_path()

        if credential_path is None:
            firebase_admin.initialize_app()
            return

        firebase_admin.initialize_app(
            credentials.Certificate(str(credential_path))
        )


def _find_credential_path() -> Path | None:
    env_path = (
        os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
        or os.getenv("FIREBASE_CREDENTIALS_PATH")
    )

    if env_path:
        return Path(env_path)

    secrets_dir = Path(__file__).resolve().parents[1] / "secrets"
    matches = list(secrets_dir.glob("*.json"))

    if matches:
        return matches[0]

    return None


def send_test_notification(token: str):
    message = messaging.Message(
        notification=messaging.Notification(
            title="AI-CCTV",
            body="FastAPI에서 보낸 FCM 테스트 알림입니다.",
        ),
        token=token,
    )

    return messaging.send(message)


def send_event_notification(tokens: list[str], event) -> dict:
    if not tokens:
        return {
            "success_count": 0,
            "failure_count": 0,
            "invalid_tokens": [],
        }

    message = messaging.MulticastMessage(
        notification=messaging.Notification(
            title="AI-CCTV 새 이벤트",
            body=f"{event.camera_id}에서 이벤트가 감지되었습니다.",
        ),
        data={
            "event_id": str(event.id),
            "camera_id": event.camera_id,
            "occurred_at": event.occurred_at.isoformat(),
            "clip_video_path": event.clip_video_path,
        },
        tokens=tokens,
    )

    response = messaging.send_each_for_multicast(message)
    invalid_tokens = [
        token
        for token, send_response in zip(tokens, response.responses)
        if not send_response.success
        and _is_invalid_token_error(send_response.exception)
    ]

    return {
        "success_count": response.success_count,
        "failure_count": response.failure_count,
        "invalid_tokens": invalid_tokens,
    }


def _is_invalid_token_error(exception: Exception | None) -> bool:
    if exception is None:
        return False

    error_code = getattr(exception, "code", None)

    return error_code in {
        "registration-token-not-registered",
        "invalid-registration-token",
    }
