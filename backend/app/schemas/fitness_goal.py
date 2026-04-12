from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class FitnessGoalBase(BaseModel):
    goal_name: str
    description: Optional[str] = None


class FitnessGoalResponse(FitnessGoalBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
