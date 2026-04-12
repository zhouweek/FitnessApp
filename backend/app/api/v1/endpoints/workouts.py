from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models import WorkoutCategory, Workout
from app.schemas import WorkoutCategoryResponse, WorkoutResponse, WorkoutDetailResponse, ResponseModel, ListResponseModel

router = APIRouter(prefix="/workouts", tags=["锻炼"])


@router.get("/categories", response_model=ListResponseModel[WorkoutCategoryResponse])
def get_categories(db: Session = Depends(get_db)):
    categories = db.query(WorkoutCategory).all()
    return ListResponseModel(
        data=[WorkoutCategoryResponse.model_validate(c) for c in categories],
        total=len(categories)
    )


@router.get("", response_model=ListResponseModel[WorkoutResponse])
def get_workouts(
    category_id: int = None,
    difficulty: str = None,
    db: Session = Depends(get_db)
):
    query = db.query(Workout)
    
    if category_id:
        query = query.filter(Workout.category_id == category_id)
    if difficulty:
        query = query.filter(Workout.difficulty == difficulty)
    
    workouts = query.all()
    return ListResponseModel(
        data=[WorkoutResponse.model_validate(w) for w in workouts],
        total=len(workouts)
    )


@router.get("/{workout_id}", response_model=ResponseModel[WorkoutDetailResponse])
def get_workout(workout_id: int, db: Session = Depends(get_db)):
    workout = db.query(Workout).filter(Workout.id == workout_id).first()
    
    if not workout:
        return ResponseModel(code=404, message="锻炼不存在", data=None)
    
    category = db.query(WorkoutCategory).filter(WorkoutCategory.id == workout.category_id).first()
    
    response = WorkoutDetailResponse(
        id=workout.id,
        category_id=workout.category_id,
        workout_name=workout.workout_name,
        description=workout.description,
        duration=workout.duration,
        calories_burned=workout.calories_burned,
        difficulty=workout.difficulty,
        equipment=workout.equipment,
        image=workout.image,
        video_url=workout.video_url,
        created_at=workout.created_at,
        category_name=category.category_name if category else None
    )
    
    return ResponseModel(data=response)
