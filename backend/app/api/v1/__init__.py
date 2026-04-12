from fastapi import APIRouter
from app.api.v1.endpoints import auth, users, goals, daily_targets, workouts, schedules, records

api_router = APIRouter()

api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(goals.router)
api_router.include_router(daily_targets.router)
api_router.include_router(workouts.router)
api_router.include_router(schedules.router)
api_router.include_router(records.router)
