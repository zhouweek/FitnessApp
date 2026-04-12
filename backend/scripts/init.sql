-- 创建数据库
CREATE DATABASE IF NOT EXISTS fitness_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 切换到 fitness_db 数据库
USE fitness_db;

-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    gender ENUM('male', 'female', 'other'),
    age INT,
    height DECIMAL(5,2),
    weight DECIMAL(5,2),
    fitness_level ENUM('beginner', 'intermediate', 'advanced'),
    avatar VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建健身目标配置表
CREATE TABLE IF NOT EXISTS fitness_goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    goal_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建每日目标表
CREATE TABLE IF NOT EXISTS daily_targets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    target_date DATE NOT NULL,
    calories_target INT,
    water_target INT,
    exercise_target INT,
    steps_target INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_date (user_id, target_date)
);

-- 创建锻炼分类表
CREATE TABLE IF NOT EXISTS workout_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建锻炼表
CREATE TABLE IF NOT EXISTS workouts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    workout_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT, -- 分钟
    calories_burned INT,
    difficulty ENUM('easy', 'medium', 'hard'),
    equipment VARCHAR(255),
    image VARCHAR(255),
    video_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES workout_categories(id) ON DELETE CASCADE
);

-- 创建锻炼计划表
CREATE TABLE IF NOT EXISTS workout_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    workout_id INT NOT NULL,
    schedule_date DATE NOT NULL,
    start_time TIME,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
);

-- 创建锻炼记录表
CREATE TABLE IF NOT EXISTS workout_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    workout_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    duration INT, -- 分钟
    calories_burned INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
);

-- 创建Token表
CREATE TABLE IF NOT EXISTS user_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    access_token VARCHAR(255) NOT NULL,
    refresh_token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 插入默认数据
INSERT IGNORE INTO fitness_goals (goal_name, description) VALUES
('Weight Loss', 'Lose body weight'),
('Muscle Gain', 'Build muscle mass'),
('Endurance', 'Improve cardiovascular endurance'),
('Flexibility', 'Increase flexibility'),
('Strength', 'Improve overall strength');

INSERT IGNORE INTO workout_categories (category_name, description) VALUES
('Cardio', 'Cardiovascular exercises'),
('Strength', 'Strength training exercises'),
('Flexibility', 'Flexibility and stretching exercises'),
('Balance', 'Balance and stability exercises'),
('HIIT', 'High-intensity interval training');

INSERT IGNORE INTO workouts (category_id, workout_name, description, duration, calories_burned, difficulty, equipment) VALUES
(1, 'Running', 'Jogging or running at a steady pace', 30, 300, 'medium', 'None'),
(1, 'Cycling', 'Stationary or outdoor cycling', 45, 400, 'medium', 'Bicycle'),
(2, 'Push Ups', 'Upper body strength exercise', 10, 50, 'easy', 'None'),
(2, 'Squats', 'Lower body strength exercise', 15, 100, 'medium', 'None'),
(3, 'Yoga', 'Flexibility and relaxation exercise', 60, 200, 'easy', 'Yoga mat');
