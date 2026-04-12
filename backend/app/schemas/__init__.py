from app.schemas.user import (
    UserBase, UserCreate, UserUpdate, UserResponse,
    Token, TokenData, LoginRequest
)
from app.schemas.fitness_goal import FitnessGoalBase, FitnessGoalResponse
from app.schemas.daily_target import (
    DailyTargetBase, DailyTargetCreate, DailyTargetUpdate, DailyTargetResponse
)
from app.schemas.workout_category import WorkoutCategoryBase, WorkoutCategoryResponse
from app.schemas.workout import WorkoutBase, WorkoutResponse, WorkoutDetailResponse
from app.schemas.workout_schedule import (
    WorkoutScheduleBase, WorkoutScheduleCreate, WorkoutScheduleUpdate,
    WorkoutScheduleResponse, WorkoutScheduleDetailResponse
)
from app.schemas.workout_record import (
    WorkoutRecordBase, WorkoutRecordCreate, WorkoutRecordComplete,
    WorkoutRecordResponse, WorkoutRecordDetailResponse
)
from app.schemas.common import ResponseModel, ListResponseModel

__all__ = [
    "UserBase", "UserCreate", "UserUpdate", "UserResponse",
    "Token", "TokenData", "LoginRequest",
    "FitnessGoalBase", "FitnessGoalResponse",
    "DailyTargetBase", "DailyTargetCreate", "DailyTargetUpdate", "DailyTargetResponse",
    "WorkoutCategoryBase", "WorkoutCategoryResponse",
    "WorkoutBase", "WorkoutResponse", "WorkoutDetailResponse",
    "WorkoutScheduleBase", "WorkoutScheduleCreate", "WorkoutScheduleUpdate",
    "WorkoutScheduleResponse", "WorkoutScheduleDetailResponse",
    "WorkoutRecordBase", "WorkoutRecordCreate", "WorkoutRecordComplete",
    "WorkoutRecordResponse", "WorkoutRecordDetailResponse",
    "ResponseModel", "ListResponseModel"
]
