from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from decimal import Decimal


class WorkoutBase(BaseModel):
    workout_name: str
    description: Optional[str] = None
    duration: Optional[int] = None
    calories_burned: Optional[int] = None
    difficulty: Optional[str] = None
    equipment: Optional[str] = None
    image: Optional[str] = None
    video_url: Optional[str] = None


class WorkoutResponse(WorkoutBase):
    id: int
    category_id: int
    created_at: datetime

    class Config:
        from_attributes = True


class WorkoutDetailResponse(WorkoutResponse):
    category_name: Optional[str] = None
