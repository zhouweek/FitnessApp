from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models import FitnessGoal
from app.schemas import FitnessGoalResponse, ResponseModel, ListResponseModel

router = APIRouter(prefix="/goals", tags=["健身目标"])


@router.get("", response_model=ListResponseModel[FitnessGoalResponse])
def get_goals(db: Session = Depends(get_db)):
    goals = db.query(FitnessGoal).all()
    return ListResponseModel(
        data=[FitnessGoalResponse.model_validate(g) for g in goals],
        total=len(goals)
    )
