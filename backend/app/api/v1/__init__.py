from fastapi import APIRouter, Request
from app.api.v1.endpoints import auth, users, goals, daily_targets, workouts, schedules, records

api_router = APIRouter()

api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(goals.router)
api_router.include_router(daily_targets.router)
api_router.include_router(workouts.router)
api_router.include_router(schedules.router)
api_router.include_router(records.router)


@api_router.api_route("/debug", methods=["GET", "POST", "PUT", "DELETE"])
async def debug_request(request: Request):
    headers = dict(request.headers)
    return {
        "method": request.method,
        "url": str(request.url),
        "headers": headers,
        "client": {
            "host": request.client.host if request.client else None,
            "port": request.client.port if request.client else None
        }
    }
