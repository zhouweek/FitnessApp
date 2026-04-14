from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1 import api_router
from app.core.database import engine, Base

# 创建数据库表
Base.metadata.create_all(bind=engine)

# 创建FastAPI应用
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_PREFIX}/openapi.json",
    docs_url=f"{settings.API_PREFIX}/docs",
    redoc_url=f"{settings.API_PREFIX}/redoc"
)

# 配置CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册路由
app.include_router(api_router, prefix=settings.API_PREFIX)


@app.get("/")
def root():
    return {
        "message": "Fitness Backend API",
        "version": settings.VERSION,
        "docs": f"{settings.API_PREFIX}/docs"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.api_route("/debug", methods=["GET", "POST", "PUT", "DELETE"])
async def debug_request(request: Request):
    headers = dict(request.headers)
    return {
        "method": request.method,
        "url": str(request.url),
        "headers": headers,
        "client": {
            "host": request.client.host if request.client else None,
            "port": request.client.port if request.client else None
        }
    }
