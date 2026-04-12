from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from app.core.database import get_db
from app.api.v1.endpoints.users import get_current_user
from app.models import User, Workout, WorkoutRecord
from app.schemas import (
    WorkoutRecordCreate, WorkoutRecordComplete,
    WorkoutRecordResponse, WorkoutRecordDetailResponse,
    ResponseModel, ListResponseModel
)

router = APIRouter(prefix="/records", tags=["锻炼记录"])


@router.get("", response_model=ListResponseModel[WorkoutRecordDetailResponse])
def get_records(
    limit: int = 20,
    offset: int = 0,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    query = db.query(WorkoutRecord).filter(WorkoutRecord.user_id == current_user.id)
    
    total = query.count()
    records = query.order_by(WorkoutRecord.start_time.desc()).offset(offset).limit(limit).all()
    
    result = []
    for r in records:
        workout = db.query(Workout).filter(Workout.id == r.workout_id).first()
        result.append(WorkoutRecordDetailResponse(
            id=r.id,
            user_id=r.user_id,
            workout_id=r.workout_id,
            start_time=r.start_time,
            end_time=r.end_time,
            duration=r.duration,
            calories_burned=r.calories_burned,
            notes=r.notes,
            created_at=r.created_at,
            workout_name=workout.workout_name if workout else None,
            workout_image=workout.image if workout else None
        ))
    
    return ListResponseModel(data=result, total=total)


@router.post("", response_model=ResponseModel[WorkoutRecordResponse])
def start_workout(
    record_data: WorkoutRecordCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    workout = db.query(Workout).filter(Workout.id == record_data.workout_id).first()
    if not workout:
        raise HTTPException(status_code=404, detail="锻炼不存在")
    
    record = WorkoutRecord(
        user_id=current_user.id,
        workout_id=record_data.workout_id,
        start_time=record_data.start_time,
        notes=record_data.notes
    )
    
    db.add(record)
    db.commit()
    db.refresh(record)
    
    return ResponseModel(data=WorkoutRecordResponse.model_validate(record))


@router.put("/{record_id}/complete", response_model=ResponseModel[WorkoutRecordResponse])
def complete_workout(
    record_id: int,
    complete_data: WorkoutRecordComplete,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    record = db.query(WorkoutRecord).filter(
        WorkoutRecord.id == record_id,
        WorkoutRecord.user_id == current_user.id
    ).first()
    
    if not record:
        raise HTTPException(status_code=404, detail="记录不存在")
    
    record.end_time = complete_data.end_time
    if complete_data.duration is not None:
        record.duration = complete_data.duration
    if complete_data.calories_burned is not None:
        record.calories_burned = complete_data.calories_burned
    if complete_data.notes is not None:
        record.notes = complete_data.notes
    
    db.commit()
    db.refresh(record)
    
    return ResponseModel(data=WorkoutRecordResponse.model_validate(record))


@router.get("/{record_id}", response_model=ResponseModel[WorkoutRecordDetailResponse])
def get_record(
    record_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    record = db.query(WorkoutRecord).filter(
        WorkoutRecord.id == record_id,
        WorkoutRecord.user_id == current_user.id
    ).first()
    
    if not record:
        raise HTTPException(status_code=404, detail="记录不存在")
    
    workout = db.query(Workout).filter(Workout.id == record.workout_id).first()
    
    response = WorkoutRecordDetailResponse(
        id=record.id,
        user_id=record.user_id,
        workout_id=record.workout_id,
        start_time=record.start_time,
        end_time=record.end_time,
        duration=record.duration,
        calories_burned=record.calories_burned,
        notes=record.notes,
        created_at=record.created_at,
        workout_name=workout.workout_name if workout else None,
        workout_image=workout.image if workout else None
    )
    
    return ResponseModel(data=response)
