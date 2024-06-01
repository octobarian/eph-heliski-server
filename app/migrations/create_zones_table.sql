CREATE TABLE IF NOT EXISTS zones (
    id SERIAL PRIMARY KEY,
    zonename VARCHAR(255) NOT NULL,
    description TEXT
);
