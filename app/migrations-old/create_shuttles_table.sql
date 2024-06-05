CREATE TABLE IF NOT EXISTS shuttles (
    id SERIAL PRIMARY KEY,
    shuttlename VARCHAR(255) NOT NULL,
    staffid INTEGER REFERENCES staff(staffid) ON DELETE SET NULL,
    description TEXT
);
