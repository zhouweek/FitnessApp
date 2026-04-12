#!/bin/bash

# 启动后端服务脚本（macOS/Linux）
echo "开始启动后端服务..."

# 进入当前目录
cd "$(dirname "$0")"

# 检查并创建虚拟环境
if [ ! -d "venv" ]; then
    echo "创建虚拟环境..."
    python3 -m venv venv
fi

# 激活虚拟环境
echo "激活虚拟环境..."
source venv/bin/activate

# 安装依赖
echo "安装依赖包..."
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 启动服务
echo "启动后端服务..."
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000