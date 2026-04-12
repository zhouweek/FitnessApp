from pydantic import BaseModel
from typing import Generic, TypeVar, Optional, List

T = TypeVar('T')


class ResponseModel(BaseModel, Generic[T]):
    code: int = 200
    message: str = "success"
    data: Optional[T] = None


class ListResponseModel(BaseModel, Generic[T]):
    code: int = 200
    message: str = "success"
    data: Optional[List[T]] = None
    total: int = 0
