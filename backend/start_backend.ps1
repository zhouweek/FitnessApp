# 启动后端服务脚本
Write-Host "开始启动后端服务..."

# 进入当前目录
Set-Location -Path "$PSScriptRoot"

# 检查并创建虚拟环境
if (-not (Test-Path "venv")) {
    Write-Host "创建虚拟环境..."
    python -m venv venv
}

# 激活虚拟环境
Write-Host "激活虚拟环境..."
& "venv\Scripts\Activate.ps1"

# 安装依赖
Write-Host "安装依赖包..."
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 启动服务
Write-Host "启动后端服务..."
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000