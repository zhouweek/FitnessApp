from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class WorkoutRecordBase(BaseModel):
    workout_id: int
    start_time: datetime
    notes: Optional[str] = None


class WorkoutRecordCreate(WorkoutRecordBase):
    pass


class WorkoutRecordComplete(BaseModel):
    end_time: datetime
    duration: Optional[int] = None
    calories_burned: Optional[int] = None
    notes: Optional[str] = None


class WorkoutRecordResponse(WorkoutRecordBase):
    id: int
    user_id: int
    end_time: Optional[datetime] = None
    duration: Optional[int] = None
    calories_burned: Optional[int] = None
    created_at: datetime

    class Config:
        from_attributes = True


class WorkoutRecordDetailResponse(WorkoutRecordResponse):
    workout_name: Optional[str] = None
    workout_image: Optional[str] = None
