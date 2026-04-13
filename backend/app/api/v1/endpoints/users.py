from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import Optional
from datetime import datetime
from app.core.database import get_db
from app.core.security import decode_token
from app.models import User, GenderEnum, FitnessLevelEnum
from app.schemas import UserUpdate, UserResponse, ResponseModel

router = APIRouter(prefix="/users", tags=["用户"])


def get_current_user(authorization: Optional[str] = Header(None), db: Session = Depends(get_db)) -> User:
    try:
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
        
        # 直接从数据库中获取原始数据，避免枚举转换错误
        from sqlalchemy import text
        result = db.execute(text("SELECT id, username, phone, email, name, gender, age, birthday, height, weight, fitness_level, avatar FROM users WHERE id = :id"), {"id": user_id}).first()
        
        if not result:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="用户不存在"
            )
        
        # 创建一个简单的用户对象，只包含基本信息
        class SimpleUser:
            def __init__(self, id, username, phone, email, name, gender, age, birthday, height, weight, fitness_level, avatar):
                self.id = id
                self.username = username
                self.phone = phone
                self.email = email
                self.name = name
                self.gender = gender
                self.age = age
                self.birthday = birthday
                self.height = height
                self.weight = weight
                self.fitness_level = fitness_level
                self.avatar = avatar
        
        return SimpleUser(*result)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"身份验证失败: {str(e)}"
        )


@router.get("/me")
def get_profile(current_user: User = Depends(get_current_user)):
    try:
        # 创建响应数据，确保枚举字段被正确处理
        response_data = {
            "id": current_user.id,
            "username": current_user.username,
            "phone": current_user.phone,
            "email": current_user.email,
            "name": current_user.name,
            "gender": current_user.gender if current_user.gender else None,
            "age": current_user.age,
            "birthday": current_user.birthday,
            "height": float(current_user.height) if current_user.height else None,
            "weight": float(current_user.weight) if current_user.weight else None,
            "fitness_level": current_user.fitness_level if current_user.fitness_level else None,
            "avatar": current_user.avatar
        }
        
        return {
            "code": 200,
            "message": "success",
            "data": response_data
        }
    except Exception as e:
        return {
            "code": 500,
            "message": f"获取用户资料失败: {e}",
            "data": None
    }


@router.put("/me")
def update_profile(
    update_data: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        # 获取用户的真实ORM对象
        user = db.query(User).filter(User.id == current_user.id).first()
        
        # 处理枚举字段，确保空值被正确处理
        if update_data.name is not None:
            user.name = update_data.name
        if update_data.gender is not None:
            if update_data.gender == "":
                user.gender = None
            else:
                try:
                    user.gender = GenderEnum(update_data.gender)
                except ValueError:
                    user.gender = None
        if update_data.age is not None:
            user.age = update_data.age
        if update_data.birthday is not None:
            user.birthday = update_data.birthday
            # 根据生日自动计算年龄
            if update_data.birthday:
                today = datetime.now()
                age = today.year - update_data.birthday.year
                if today.month < update_data.birthday.month or (today.month == update_data.birthday.month and today.day < update_data.birthday.day):
                    age -= 1
                user.age = age
        if update_data.height is not None:
            user.height = update_data.height
        if update_data.weight is not None:
            user.weight = update_data.weight
        if update_data.fitness_level is not None:
            if update_data.fitness_level == "":
                user.fitness_level = None
            else:
                try:
                    user.fitness_level = FitnessLevelEnum(update_data.fitness_level)
                except ValueError:
                    user.fitness_level = None
        if update_data.avatar is not None:
            user.avatar = update_data.avatar
        
        db.commit()
        db.refresh(user)
        
        # 创建响应数据
        response_data = {
            "id": user.id,
            "username": user.username,
            "phone": user.phone,
            "email": user.email,
            "name": user.name,
            "gender": user.gender.value if user.gender else None,
            "age": user.age,
            "birthday": user.birthday,
            "height": float(user.height) if user.height else None,
            "weight": float(user.weight) if user.weight else None,
            "fitness_level": user.fitness_level.value if user.fitness_level else None,
            "avatar": user.avatar
        }
        
        return {
            "code": 200,
            "message": "success",
            "data": response_data
        }
    except Exception as e:
        db.rollback()
        # 打印详细的错误信息
        import traceback
        traceback.print_exc()
        return {
            "code": 500,
            "message": f"更新用户资料失败: {str(e)}",
            "data": None
        }
