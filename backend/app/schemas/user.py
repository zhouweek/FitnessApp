from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from decimal import Decimal
from app.models import GenderEnum, FitnessLevelEnum


class UserBase(BaseModel):
    username: str
    email: EmailStr


class UserCreate(BaseModel):
    phone: str
    password: str
    username: str
    email: Optional[EmailStr] = None
    name: Optional[str] = None
    gender: Optional[str] = None
    age: Optional[int] = None
    birthday: Optional[datetime] = None
    height: Optional[Decimal] = None
    weight: Optional[Decimal] = None
    fitness_level: Optional[str] = None


class UserUpdate(BaseModel):
    name: Optional[str] = None
    gender: Optional[str] = None
    age: Optional[int] = None
    birthday: Optional[datetime] = None
    height: Optional[Decimal] = None
    weight: Optional[Decimal] = None
    fitness_level: Optional[str] = None
    avatar: Optional[str] = None


class UserResponse(BaseModel):
    id: int
    username: str
    phone: str
    email: Optional[str] = None
    name: Optional[str] = None
    gender: Optional[str] = None
    age: Optional[int] = None
    birthday: Optional[datetime] = None
    height: Optional[float] = None
    weight: Optional[float] = None
    fitness_level: Optional[str] = None

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class LoginResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: UserResponse


class TokenData(BaseModel):
    user_id: Optional[int] = None


class LoginRequest(BaseModel):
    username: Optional[str] = None
    phone: Optional[str] = None
    password: str
