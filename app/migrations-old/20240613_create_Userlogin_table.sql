-- 2024-06-13-create-user-logins-table.sql

-- Enable the pgcrypto extension if it is not already enabled
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create the user_logins table if it does not exist
CREATE TABLE IF NOT EXISTS user_logins (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    staff_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(staffid) ON DELETE SET NULL
);
