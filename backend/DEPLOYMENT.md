# Fitness Backend API 部署指南

本指南将帮助您在 Render.com 上部署 Fitness App 项目的后端服务。

## 项目结构

```
FitnessApp/
├── backend/         # 后端代码 (FastAPI)
├── lib/             # Flutter 前端代码
├── android/         # Android 构建配置
├── render.yaml      # Render.com 部署配置
└── README.md        # 项目概览
```

## 部署准备

### 1. 准备 GitHub 仓库

1. **Fork 项目**：将此项目 Fork 到您自己的 GitHub 账号
2. **克隆仓库**：在本地克隆您 Fork 的仓库

### 2. 注册 Render.com 账号

1. 访问 [Render.com](https://render.com)
2. 点击 "Sign Up" 注册账号
3. 选择使用 GitHub 登录（推荐）

## 部署步骤

### 步骤 1：连接 GitHub 仓库

1. 登录 Render.com 后，点击仪表盘上的 "New" 按钮
2. 选择 "Web Service"
3. 在 "Connect a Repository" 页面，选择您 Fork 的 FitnessApp 仓库
4. 点击 "Connect"

### 步骤 2：配置部署设置

1. **Name**：输入服务名称（如 `fitness-backend`）
2. **Region**：选择最近的区域（推荐 `Oregon (us-west)`）
3. **Branch**：选择 `main` 分支
4. **Root Directory**：留空（默认）
5. **Environment**：选择 `Docker`
6. **Dockerfile Path**：输入 `backend/Dockerfile`
7. **Docker Context**：输入 `backend`

### 步骤 3：设置环境变量

在 "Environment Variables" 部分，添加以下变量：

| 变量名 | 值 | 说明 |
|-------|-----|-----|
| `DATABASE_URL` | `sqlite:///./fitness.db` | SQLite 数据库路径 |
| `SECRET_KEY` | 点击 "Generate" | 用于 JWT 签名的密钥 |
| `ALGORITHM` | `HS256` | JWT 算法 |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `1440` | 访问令牌过期时间（分钟） |
| `REFRESH_TOKEN_EXPIRE_DAYS` | `7` | 刷新令牌过期时间（天） |
| `PROJECT_NAME` | `Fitness Backend API` | 项目名称 |
| `VERSION` | `1.0.0` | 版本号 |
| `API_PREFIX` | `/api/v1` | API 路由前缀 |
| `DEBUG` | `True` | 调试模式 |

### 步骤 4：部署服务

1. 点击 "Create Web Service"
2. Render.com 将开始构建和部署您的服务
3. 等待部署完成（通常需要 2-5 分钟）

### 步骤 5：验证部署

部署完成后：

1. 点击服务名称进入详情页
2. 复制 "URL"（如 `https://fitness-backend-abc123.onrender.com`）
3. 在浏览器中访问：
   - 健康检查：`https://fitness-backend-abc123.onrender.com/health`
   - API 文档：`https://fitness-backend-abc123.onrender.com/api/v1/docs`

## 前端配置

部署完成后，需要更新 Flutter 前端的 API 地址：

1. 打开 `lib/utils/api_config.dart` 文件
2. 将 `baseUrl` 修改为您的 Render.com 服务地址：

```dart
static const String baseUrl = 'https://fitness-backend-abc123.onrender.com/api/v1';
```

## 常见问题

### 1. 部署失败怎么办？

- 查看部署日志，检查错误信息
- 确保 Dockerfile 路径正确
- 检查环境变量设置是否完整

### 2. API 无法访问？

- 检查服务是否处于 "Live" 状态
- 验证环境变量中的 `API_PREFIX` 设置
- 尝试访问健康检查端点确认服务运行正常

### 3. 数据库连接问题？

- 本项目使用 SQLite 数据库，无需额外配置
- 确保 `DATABASE_URL` 设置正确

### 4. 免费计划限制？

- Render.com 免费计划有以下限制：
  - 每月 750 小时运行时间
  - 服务会在 15 分钟无活动后自动休眠
  - 重新激活需要几秒钟时间

## 本地开发

### 启动后端服务

```bash
# 进入 backend 目录
cd backend

# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
# Windows: venv\Scripts\activate
# Linux/Mac: source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 运行服务
uvicorn app.main:app --reload
```

### 启动前端应用

```bash
# 进入项目根目录
cd FitnessApp

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

## 技术栈

- **后端**：FastAPI + Python 3.11
- **数据库**：SQLite
- **认证**：JWT
- **前端**：Flutter
- **部署**：Render.com (Docker)

## 支持

如果遇到部署问题，请：
1. 检查 Render.com 文档
2. 查看本文件的详细说明
3. 联系项目维护者

---

**祝您部署成功！** 🎉