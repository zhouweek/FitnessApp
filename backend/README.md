# Fitness Backend 部署文档

## 项目结构

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── endpoints/       # API端点
│   │       │   ├── auth.py      # 认证接口
│   │       │   ├── users.py     # 用户接口
│   │       │   ├── goals.py     # 目标接口
│   │       │   ├── daily_targets.py  # 每日目标接口
│   │       │   ├── workouts.py  # 锻炼接口
│   │       │   ├── schedules.py # 计划接口
│   │       │   └── records.py   # 记录接口
│   │       └── __init__.py
│   ├── core/
│   │   ├── config.py            # 配置
│   │   ├── database.py          # 数据库
│   │   └── security.py          # 安全
│   ├── models/                  # 数据库模型
│   ├── schemas/                 # Pydantic模型
│   └── main.py                  # 入口文件
├── scripts/
│   └── init.sql                 # 数据库初始化脚本
├── uploads/                     # 上传文件目录
├── .env                         # 环境变量
├── docker-compose.yml           # Docker编排
├── Dockerfile                   # Docker镜像
├── requirements.txt             # Python依赖
└── README.md                    # 说明文档
```

## 方式一：Docker部署（推荐）

### 前置要求
- Docker Desktop 已安装
- Docker Compose 已安装

### 步骤

1. **进入backend目录**
```bash
cd D:\0project\FitnessApp\backend
```

2. **启动所有服务**
```bash
docker-compose up -d
```

3. **查看服务状态**
```bash
docker-compose ps
```

4. **查看日志**
```bash
docker-compose logs -f backend
```

5. **停止服务**
```bash
docker-compose down
```

### 访问地址
- API地址: http://localhost:8000
- API文档: http://localhost:8000/api/v1/docs
- ReDoc文档: http://localhost:8000/api/v1/redoc

---

## 方式二：本地开发部署

### 前置要求
- Python 3.11+
- MySQL 8.0+
- Redis（可选）

### 步骤

1. **创建虚拟环境**
```bash
cd D:\0project\FitnessApp\backend
python -m venv venv
```

2. **激活虚拟环境**
```bash
# Windows
.\venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

3. **安装依赖**
```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

4. **创建MySQL数据库**
```sql
CREATE DATABASE fitness_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

5. **导入初始数据**
```bash
mysql -u root -p fitness_db < scripts/init.sql
```

6. **修改环境变量**
编辑 `.env` 文件，修改数据库连接信息：
```
DATABASE_URL=mysql+pymysql://root:你的密码@localhost:3306/fitness_db
```

7. **启动服务**
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## API接口列表

### 认证模块
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/v1/auth/register | 用户注册 |
| POST | /api/v1/auth/login | 用户登录 |
| POST | /api/v1/auth/refresh | 刷新Token |

### 用户模块
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/v1/users/me | 获取当前用户信息 |
| PUT | /api/v1/users/me | 更新用户信息 |

### 目标模块
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/v1/goals | 获取健身目标列表 |

### 每日目标模块
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/v1/daily-targets | 获取每日目标 |
| POST | /api/v1/daily-targets | 设置每日目标 |
| PUT | /api/v1/daily-targets | 更新每日目标 |

### 锻炼模块
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/v1/workouts/categories | 获取锻炼分类 |
| GET | /api/v1/workouts | 获取锻炼列表 |
| GET | /api/v1/workouts/{id} | 获取锻炼详情 |

### 计划模块
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/v1/schedules | 获取计划列表 |
| POST | /api/v1/schedules | 创建计划 |
| PUT | /api/v1/schedules/{id} | 更新计划 |
| DELETE | /api/v1/schedules/{id} | 删除计划 |

### 记录模块
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/v1/records | 获取记录列表 |
| POST | /api/v1/records | 开始锻炼 |
| PUT | /api/v1/records/{id}/complete | 完成锻炼 |
| GET | /api/v1/records/{id} | 获取记录详情 |

---

## Flutter App配置

### 修改API地址

编辑 `lib/utils/api_config.dart` 文件：

```dart
class ApiConfig {
  // 本地开发
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // 模拟器访问本机
  // static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  
  // 真机访问（替换为电脑IP）
  // static const String baseUrl = 'http://192.168.1.100:8000/api/v1';
  
  // 生产环境
  // static const String baseUrl = 'https://your-domain.com/api/v1';
}
```

### 安装依赖
```bash
cd D:\0project\FitnessApp
flutter pub get
```

---

## 常见问题

### 1. 数据库连接失败
- 检查MySQL服务是否启动
- 检查用户名密码是否正确
- 检查数据库是否已创建

### 2. 端口被占用
```bash
# Windows查看端口占用
netstat -ano | findstr :8000

# 结束进程
taskkill /PID <进程ID> /F
```

### 3. Docker启动失败
- 确保Docker Desktop已启动
- 确保端口3306、6379、8000未被占用

### 4. Flutter无法连接后端
- 检查API地址配置
- 确保后端服务已启动
- 检查防火墙设置

---

## 生产环境建议

1. **修改SECRET_KEY**
   - 生成强随机密钥替换 `.env` 中的 `SECRET_KEY`

2. **配置HTTPS**
   - 使用Nginx反向代理
   - 配置SSL证书

3. **数据库优化**
   - 配置主从复制
   - 定期备份

4. **监控告警**
   - 配置日志收集
   - 设置性能监控
