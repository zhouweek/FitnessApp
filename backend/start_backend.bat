@echo off

REM 启动后端服务脚本
echo 开始启动后端服务...

REM 进入当前目录
cd /d "%~dp0"

REM 检查并创建虚拟环境
if not exist "venv" (
    echo 创建虚拟环境...
    python -m venv venv
)

REM 激活虚拟环境
echo 激活虚拟环境...
call venv\Scripts\activate

REM 安装依赖
echo 安装依赖包...
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

REM 启动服务
echo 启动后端服务...
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

pause