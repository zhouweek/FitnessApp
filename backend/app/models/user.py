from sqlalchemy import Column, Integer, String, Enum, DateTime, DECIMAL
from sqlalchemy.sql import func
from app.core.database import Base
import enum


class GenderEnum(str, enum.Enum):
    male = "male"
    female = "female"
    other = "other"


class FitnessLevelEnum(str, enum.Enum):
    beginner = "beginner"
    intermediate = "intermediate"
    advanced = "advanced"


class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False, index=True)
    email = Column(String(100), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    name = Column(String(100))
    gender = Column(Enum(GenderEnum))
    age = Column(Integer)
    height = Column(DECIMAL(5, 2))
    weight = Column(DECIMAL(5, 2))
    fitness_level = Column(Enum(FitnessLevelEnum))
    avatar = Column(String(255))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
