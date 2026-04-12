from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date
from app.core.database import get_db
from app.api.v1.endpoints.users import get_current_user
from app.models import User, Workout, WorkoutCategory, WorkoutSchedule
from app.schemas import (
    WorkoutScheduleCreate, WorkoutScheduleUpdate,
    WorkoutScheduleResponse, WorkoutScheduleDetailResponse,
    ResponseModel, ListResponseModel
)

router = APIRouter(prefix="/schedules", tags=["锻炼计划"])


@router.get("", response_model=ListResponseModel[WorkoutScheduleDetailResponse])
def get_schedules(
    schedule_date: date = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    query = db.query(WorkoutSchedule).filter(WorkoutSchedule.user_id == current_user.id)
    
    if schedule_date:
        query = query.filter(WorkoutSchedule.schedule_date == schedule_date)
    
    schedules = query.order_by(WorkoutSchedule.schedule_date, WorkoutSchedule.start_time).all()
    
    result = []
    for s in schedules:
        workout = db.query(Workout).filter(Workout.id == s.workout_id).first()
        result.append(WorkoutScheduleDetailResponse(
            id=s.id,
            user_id=s.user_id,
            workout_id=s.workout_id,
            schedule_date=s.schedule_date,
            start_time=s.start_time,
            is_completed=s.is_completed,
            created_at=s.created_at,
            updated_at=s.updated_at,
            workout_name=workout.workout_name if workout else None,
            workout_image=workout.image if workout else None,
            duration=workout.duration if workout else None,
            calories_burned=workout.calories_burned if workout else None
        ))
    
    return ListResponseModel(data=result, total=len(result))


@router.post("", response_model=ResponseModel[WorkoutScheduleResponse])
def create_schedule(
    schedule_data: WorkoutScheduleCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    workout = db.query(Workout).filter(Workout.id == schedule_data.workout_id).first()
    if not workout:
        raise HTTPException(status_code=404, detail="锻炼不存在")
    
    schedule = WorkoutSchedule(
        user_id=current_user.id,
        workout_id=schedule_data.workout_id,
        schedule_date=schedule_data.schedule_date,
        start_time=schedule_data.start_time
    )
    
    db.add(schedule)
    db.commit()
    db.refresh(schedule)
    
    return ResponseModel(data=WorkoutScheduleResponse.model_validate(schedule))


@router.put("/{schedule_id}", response_model=ResponseModel[WorkoutScheduleResponse])
def update_schedule(
    schedule_id: int,
    update_data: WorkoutScheduleUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    schedule = db.query(WorkoutSchedule).filter(
        WorkoutSchedule.id == schedule_id,
        WorkoutSchedule.user_id == current_user.id
    ).first()
    
    if not schedule:
        raise HTTPException(status_code=404, detail="计划不存在")
    
    if update_data.schedule_date is not None:
        schedule.schedule_date = update_data.schedule_date
    if update_data.start_time is not None:
        schedule.start_time = update_data.start_time
    if update_data.is_completed is not None:
        schedule.is_completed = update_data.is_completed
    
    db.commit()
    db.refresh(schedule)
    
    return ResponseModel(data=WorkoutScheduleResponse.model_validate(schedule))


@router.delete("/{schedule_id}", response_model=ResponseModel)
def delete_schedule(
    schedule_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    schedule = db.query(WorkoutSchedule).filter(
        WorkoutSchedule.id == schedule_id,
        WorkoutSchedule.user_id == current_user.id
    ).first()
    
    if not schedule:
        raise HTTPException(status_code=404, detail="计划不存在")
    
    db.delete(schedule)
    db.commit()
    
    return ResponseModel(message="删除成功")
