from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from typing import Optional
from app.core.database import get_db
from app.core.security import decode_token
from app.models import User
from app.schemas import UserUpdate, UserResponse, ResponseModel

router = APIRouter(prefix="/users", tags=["用户"])


def get_current_user(authorization: Optional[str] = Header(None), db: Session = Depends(get_db)) -> User:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="未提供认证令牌"
        )
    
    token = authorization.replace("Bearer ", "")
    payload = decode_token(token)
    
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="无效的令牌"
        )
    
    user_id = int(payload.get("sub"))
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="用户不存在"
        )
    
    return user


@router.get("/me", response_model=ResponseModel[UserResponse])
def get_profile(current_user: User = Depends(get_current_user)):
    return ResponseModel(data=UserResponse.model_validate(current_user))


@router.put("/me", response_model=ResponseModel[UserResponse])
def update_profile(
    update_data: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if update_data.name is not None:
        current_user.name = update_data.name
    if update_data.gender is not None:
        current_user.gender = update_data.gender
    if update_data.age is not None:
        current_user.age = update_data.age
    if update_data.height is not None:
        current_user.height = update_data.height
    if update_data.weight is not None:
        current_user.weight = update_data.weight
    if update_data.fitness_level is not None:
        current_user.fitness_level = update_data.fitness_level
    if update_data.avatar is not None:
        current_user.avatar = update_data.avatar
    
    db.commit()
    db.refresh(current_user)
    
    return ResponseModel(data=UserResponse.model_validate(current_user))
