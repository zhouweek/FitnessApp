from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import verify_password, get_password_hash, create_access_token, create_refresh_token, decode_token
from app.models import User, UserToken
from app.schemas import UserCreate, UserResponse, Token, LoginRequest, ResponseModel
from datetime import datetime, timedelta
from app.core.config import settings

router = APIRouter(prefix="/auth", tags=["认证"])


@router.post("/register", response_model=ResponseModel[UserResponse])
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(
        (User.username == user_data.username) | (User.phone == user_data.phone)
    ).first()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="用户名或手机号已存在"
        )
    
    user = User(
        username=user_data.username,
        email=user_data.email,
        phone=user_data.phone,
        password_hash=get_password_hash(user_data.password),
        name=user_data.name,
        gender=user_data.gender,
        age=user_data.age,
        height=user_data.height,
        weight=user_data.weight,
        fitness_level=user_data.fitness_level
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    return ResponseModel(data=UserResponse.model_validate(user))


@router.post("/login", response_model=ResponseModel[Token])
def login(login_data: LoginRequest, db: Session = Depends(get_db)):
    # 优先使用手机号登录，如果没有提供手机号则使用用户名
    if login_data.phone:
        user = db.query(User).filter(User.phone == login_data.phone).first()
    elif login_data.username:
        user = db.query(User).filter(User.username == login_data.username).first()
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="请提供用户名或手机号"
        )
    
    if not user or not verify_password(login_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="用户名或密码错误"
        )
    
    access_token = create_access_token(data={"sub": str(user.id)})
    refresh_token = create_refresh_token(data={"sub": str(user.id)})
    
    expires_at = datetime.utcnow() + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    user_token = UserToken(
        user_id=user.id,
        access_token=access_token,
        refresh_token=refresh_token,
        expires_at=expires_at
    )
    db.add(user_token)
    db.commit()
    
    return ResponseModel(data=Token(
        access_token=access_token,
        refresh_token=refresh_token
    ))


@router.post("/refresh", response_model=ResponseModel[Token])
def refresh_token(refresh_token: str, db: Session = Depends(get_db)):
    payload = decode_token(refresh_token)
    
    if not payload or payload.get("type") != "refresh":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="无效的刷新令牌"
        )
    
    user_id = int(payload.get("sub"))
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="用户不存在"
        )
    
    new_access_token = create_access_token(data={"sub": str(user.id)})
    new_refresh_token = create_refresh_token(data={"sub": str(user.id)})
    
    expires_at = datetime.utcnow() + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    user_token = UserToken(
        user_id=user.id,
        access_token=new_access_token,
        refresh_token=new_refresh_token,
        expires_at=expires_at
    )
    db.add(user_token)
    db.commit()
    
    return ResponseModel(data=Token(
        access_token=new_access_token,
        refresh_token=new_refresh_token
    ))
