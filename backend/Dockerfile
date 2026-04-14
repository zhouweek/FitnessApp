FROM python:3.11-slim

WORKDIR /app

# 关键修复：从 backend/ 目录复制 requirements.txt
COPY requirements.txt .

# 安装依赖
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制整个 backend 目录到容器
COPY backend/ .

# 启动命令（适配 Render 动态端口）
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]