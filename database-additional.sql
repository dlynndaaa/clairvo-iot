-- Tabel untuk tracking alert/warning
CREATE TABLE sensor_alerts (
  id SERIAL PRIMARY KEY,
  sensor_reading_id INT REFERENCES sensor_readings(id) ON DELETE CASCADE,
  alert_type VARCHAR(50) NOT NULL, -- 'BERBAHAYA', 'WARNING'
  alert_category VARCHAR(50) NOT NULL, -- 'temperature', 'co2', 'particulate'
  current_value NUMERIC,
  threshold_value NUMERIC,
  status VARCHAR(20) DEFAULT 'active', -- 'active', 'resolved'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP,
  resolved_by INT REFERENCES users(id)
);

-- Tabel untuk tracking history kipas ON/OFF
CREATE TABLE fan_logs (
  id SERIAL PRIMARY KEY,
  fan_status INT NOT NULL, -- 0 = OFF, 1 = ON
  triggered_by VARCHAR(50) NOT NULL, -- 'manual', 'auto_sensor'
  user_id INT REFERENCES users(id),
  reason TEXT, -- Alasan mengapa kipas ON/OFF
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Update tabel sensor_readings dengan kolom tambahan
ALTER TABLE sensor_readings 
ADD COLUMN IF NOT EXISTS location VARCHAR(100),
ADD COLUMN IF NOT EXISTS device_id VARCHAR(100);

-- Index untuk optimasi query
CREATE INDEX IF NOT EXISTS idx_sensor_readings_created_at ON sensor_readings(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sensor_readings_status ON sensor_readings(air_quality_status);
CREATE INDEX IF NOT EXISTS idx_sensor_alerts_created_at ON sensor_alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sensor_alerts_status ON sensor_alerts(status);
CREATE INDEX IF NOT EXISTS idx_fan_logs_created_at ON fan_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_login_history_user_id ON login_history(user_id);

-- View untuk mendapatkan alert terbaru
CREATE OR REPLACE VIEW latest_alerts AS
SELECT 
  sa.id,
  sa.alert_type,
  sa.alert_category,
  sa.current_value,
  sa.threshold_value,
  sa.status,
  sa.created_at,
  sr.temperature,
  sr.co2,
  sr.particulate
FROM sensor_alerts sa
JOIN sensor_readings sr ON sa.sensor_reading_id = sr.id
WHERE sa.status = 'active'
ORDER BY sa.created_at DESC
LIMIT 10;

-- View untuk statistik harian
CREATE OR REPLACE VIEW daily_statistics AS
SELECT 
  DATE(created_at) as date,
  AVG(temperature) as avg_temperature,
  MAX(temperature) as max_temperature,
  MIN(temperature) as min_temperature,
  AVG(co2) as avg_co2,
  MAX(co2) as max_co2,
  MIN(co2) as min_co2,
  AVG(particulate) as avg_particulate,
  MAX(particulate) as max_particulate,
  MIN(particulate) as min_particulate,
  COUNT(*) as total_readings
FROM sensor_readings
GROUP BY DATE(created_at)
ORDER BY date DESC;
