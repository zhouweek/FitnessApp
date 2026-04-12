from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date
from app.core.database import get_db
from app.api.v1.endpoints.users import get_current_user
from app.models import User, DailyTarget
from app.schemas import DailyTargetCreate, DailyTargetUpdate, DailyTargetResponse, ResponseModel

router = APIRouter(prefix="/daily-targets", tags=["每日目标"])


@router.get("", response_model=ResponseModel[DailyTargetResponse])
def get_daily_target(
    target_date: date,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    target = db.query(DailyTarget).filter(
        DailyTarget.user_id == current_user.id,
        DailyTarget.target_date == target_date
    ).first()
    
    if not target:
        return ResponseModel(data=None)
    
    return ResponseModel(data=DailyTargetResponse.model_validate(target))


@router.post("", response_model=ResponseModel[DailyTargetResponse])
def set_daily_target(
    target_data: DailyTargetCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    existing = db.query(DailyTarget).filter(
        DailyTarget.user_id == current_user.id,
        DailyTarget.target_date == target_data.target_date
    ).first()
    
    if existing:
        if target_data.calories_target is not None:
            existing.calories_target = target_data.calories_target
        if target_data.water_target is not None:
            existing.water_target = target_data.water_target
        if target_data.exercise_target is not None:
            existing.exercise_target = target_data.exercise_target
        if target_data.steps_target is not None:
            existing.steps_target = target_data.steps_target
        db.commit()
        db.refresh(existing)
        return ResponseModel(data=DailyTargetResponse.model_validate(existing))
    
    target = DailyTarget(
        user_id=current_user.id,
        target_date=target_data.target_date,
        calories_target=target_data.calories_target,
        water_target=target_data.water_target,
        exercise_target=target_data.exercise_target,
        steps_target=target_data.steps_target
    )
    
    db.add(target)
    db.commit()
    db.refresh(target)
    
    return ResponseModel(data=DailyTargetResponse.model_validate(target))


@router.put("", response_model=ResponseModel[DailyTargetResponse])
def update_daily_target(
    target_date: date,
    update_data: DailyTargetUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    target = db.query(DailyTarget).filter(
        DailyTarget.user_id == current_user.id,
        DailyTarget.target_date == target_date
    ).first()
    
    if not target:
        raise HTTPException(status_code=404, detail="目标不存在")
    
    if update_data.calories_target is not None:
        target.calories_target = update_data.calories_target
    if update_data.water_target is not None:
        target.water_target = update_data.water_target
    if update_data.exercise_target is not None:
        target.exercise_target = update_data.exercise_target
    if update_data.steps_target is not None:
        target.steps_target = update_data.steps_target
    
    db.commit()
    db.refresh(target)
    
    return ResponseModel(data=DailyTargetResponse.model_validate(target))
