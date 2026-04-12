from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class WorkoutCategoryBase(BaseModel):
    category_name: str
    description: Optional[str] = None


class WorkoutCategoryResponse(WorkoutCategoryBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
