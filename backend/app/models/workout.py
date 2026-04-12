from sqlalchemy import Column, Integer, String, Text, Enum, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.core.database import Base
import enum


class DifficultyEnum(str, enum.Enum):
    easy = "easy"
    medium = "medium"
    hard = "hard"


class Workout(Base):
    __tablename__ = "workouts"
    
    id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer, ForeignKey("workout_categories.id", ondelete="CASCADE"), nullable=False, index=True)
    workout_name = Column(String(100), nullable=False, index=True)
    description = Column(Text)
    duration = Column(Integer)  # 分钟
    calories_burned = Column(Integer)
    difficulty = Column(Enum(DifficultyEnum))
    equipment = Column(String(255))
    image = Column(String(255))
    video_url = Column(String(255))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
