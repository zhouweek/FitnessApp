# FitnessApp 业务流程分析

## 1. 应用启动流程

1. **Onboarding 引导**
   - 展示应用功能介绍
   - 引导用户了解应用的主要特性

2. **Start 屏幕**
   - 提供开始使用应用的入口

3. **Welcome 屏幕**
   - 欢迎用户并提供登录/注册选项

## 2. 认证流程

### 2.1 注册功能
1. **注册页面 (SignupScreen)**
   - 收集用户基本信息：
     - 名字 (First Name)
     - 姓氏 (Last Name)
     - 邮箱 (Email)
     - 密码 (Password)
   - 提供隐私政策和使用条款同意
   - 支持Google和Facebook第三方登录
   - 注册成功后跳转到完成个人资料页面

2. **完成个人资料 (CompleteProfileScreen)**
   - 收集用户详细信息：
     - 性别 (Gender)
     - 出生日期 (Date of Birth)
     - 体重 (Weight)
     - 身高 (Height)
   - 完成后跳转到设置健身目标页面

3. **设置健身目标 (YourGoalScreen)**
   - 提供三种健身目标选择：
     - Improve Shape (增肌塑形)
     - Lean & Tone (减脂增肌)
     - Lose a Fat (减重减脂)
   - 选择目标后跳转到欢迎页面

### 2.2 登录功能
1. **登录页面 (LoginScreen)**
   - 提供邮箱和密码登录
   - 支持忘记密码功能
   - 支持Google和Facebook第三方登录
   - 登录成功后跳转到完成个人资料页面

## 3. 主要功能模块

### 3.1 首页 (HomeScreen)
- **BMI 指数展示**
  - 显示用户BMI状态
  - 提供查看更多详情选项

- **今日目标**
  - 展示当日健身目标
  - 提供查看活动追踪入口

- **活动状态**
  - 心率监测和历史数据
  - 实时心率图表展示

- **水分摄入**
  - 展示每日水分摄入目标
  - 分时段记录水分摄入量

- **睡眠监测**
  - 展示睡眠时长
  - 睡眠质量图表

- **卡路里消耗**
  - 展示当日卡路里消耗
  - 剩余卡路里目标

- **锻炼进度**
  - 周/月锻炼进度图表
  - 历史锻炼记录

### 3.2 活动追踪 (ActivityTrackerScreen)
- 追踪用户日常活动
- 展示活动数据和目标完成情况

### 3.3 活动页面 (ActivityScreen)
- 展示即将进行的锻炼
- 提供锻炼类型选择

### 3.4 相机页面 (CameraScreen)
- 可能用于拍摄锻炼过程或进度照片

### 3.5 通知页面 (NotificationScreen)
- 展示应用通知
- 锻炼提醒和其他通知

### 3.6 个人资料 (UserProfile)
- 展示用户个人信息
- 提供设置选项

### 3.7 锻炼详情 (WorkoutDetailView)
- 展示锻炼详情和步骤
- 提供锻炼指导

### 3.8 锻炼计划 (WorkoutScheduleView)
- 管理用户的锻炼计划
- 支持添加新的锻炼计划

### 3.9 完成锻炼 (FinishWorkoutScreen)
- 锻炼完成后的总结页面
- 展示锻炼成果和数据

## 4. 核心业务流程

### 4.1 新用户注册流程
1. 进入注册页面 → 填写基本信息 → 同意条款 → 点击注册
2. 进入完成个人资料页面 → 填写详细信息 → 点击下一步
3. 进入设置健身目标页面 → 选择目标 → 点击确认
4. 进入欢迎页面 → 开始使用应用

### 4.2 现有用户登录流程
1. 进入登录页面 → 输入邮箱和密码 → 点击登录
2. 进入应用首页 → 开始使用应用

### 4.3 锻炼流程
1. 从首页或活动页面选择锻炼
2. 查看锻炼详情和步骤
3. 开始锻炼
4. 完成锻炼 → 查看锻炼成果

### 4.4 日常活动追踪流程
1. 进入活动追踪页面
2. 查看当日活动数据
3. 完成活动目标

## 5. 技术实现特点

- 使用Flutter跨平台开发
- 采用组件化架构
- 支持响应式布局
- 集成第三方图表库展示数据
- 支持第三方登录
- 本地状态管理

## 6. 页面路由

- `/SignupScreen` - 注册页面
- `/CompleteProfileScreen` - 完成个人资料页面
- `/YourGoalScreen` - 设置健身目标页面
- `/LoginScreen` - 登录页面
- `/WelcomeScreen` - 欢迎页面
- `/HomeScreen` - 首页
- `/ActivityTrackerScreen` - 活动追踪页面
- `/ActivityScreen` - 活动页面
- `/CameraScreen` - 相机页面
- `/NotificationScreen` - 通知页面
- `/UserProfile` - 个人资料页面
- `/WorkoutDetailView` - 锻炼详情页面
- `/WorkoutScheduleView` - 锻炼计划页面
- `/FinishWorkoutScreen` - 完成锻炼页面
- `/OnBoardingScreen` - 引导页面
- `/StartScreen` - 开始页面