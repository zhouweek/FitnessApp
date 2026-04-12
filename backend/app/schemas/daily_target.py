from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime


class DailyTargetBase(BaseModel):
    target_date: date
    calories_target: Optional[int] = None
    water_target: Optional[int] = None
    exercise_target: Optional[int] = None
    steps_target: Optional[int] = None


class DailyTargetCreate(DailyTargetBase):
    pass


class DailyTargetUpdate(BaseModel):
    calories_target: Optional[int] = None
    water_target: Optional[int] = None
    exercise_target: Optional[int] = None
    steps_target: Optional[int] = None


class DailyTargetResponse(DailyTargetBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
