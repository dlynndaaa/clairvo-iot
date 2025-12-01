-- Create database
CREATE DATABASE clairvo_iot;

-- Connect to clairvo_iot database
\c clairvo_iot;

-- Users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensor data table
CREATE TABLE sensor_readings (
  id SERIAL PRIMARY KEY,
  temperature DECIMAL(5, 2) NOT NULL,
  co2 INTEGER NOT NULL,
  particulate DECIMAL(6, 2) NOT NULL,
  air_quality_status VARCHAR(50) NOT NULL,
  fan_status BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fan control settings table
CREATE TABLE fan_settings (
  id SERIAL PRIMARY KEY,
  is_auto_mode BOOLEAN NOT NULL DEFAULT TRUE,
  fan_on_threshold_co2 INTEGER DEFAULT 150,
  fan_on_threshold_particulate DECIMAL(6, 2) DEFAULT 50,
  danger_threshold_co2 INTEGER DEFAULT 250,
  danger_threshold_particulate DECIMAL(6, 2) DEFAULT 75,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_by INTEGER REFERENCES users(id)
);

-- Login history table
CREATE TABLE login_history (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  logout_time TIMESTAMP,
  ip_address VARCHAR(50)
);

-- Create indexes for faster queries
CREATE INDEX idx_sensor_readings_created_at ON sensor_readings(created_at);
CREATE INDEX idx_login_history_user_id ON login_history(user_id);
CREATE INDEX idx_users_email ON users(email);

-- Insert default user for demo
INSERT INTO users (email, password, name) VALUES 
('admin@clairvo.com', 'password123', 'Admin Bengkel');

-- Insert default fan settings
INSERT INTO fan_settings (is_auto_mode) VALUES (TRUE);
