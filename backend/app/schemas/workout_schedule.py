from pydantic import BaseModel
from typing import Optional
from datetime import date, time, datetime


class WorkoutScheduleBase(BaseModel):
    workout_id: int
    schedule_date: date
    start_time: Optional[time] = None


class WorkoutScheduleCreate(WorkoutScheduleBase):
    pass


class WorkoutScheduleUpdate(BaseModel):
    schedule_date: Optional[date] = None
    start_time: Optional[time] = None
    is_completed: Optional[bool] = None


class WorkoutScheduleResponse(WorkoutScheduleBase):
    id: int
    user_id: int
    is_completed: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class WorkoutScheduleDetailResponse(WorkoutScheduleResponse):
    workout_name: Optional[str] = None
    workout_image: Optional[str] = None
    duration: Optional[int] = None
    calories_burned: Optional[int] = None
