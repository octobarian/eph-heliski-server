-- create-trainingtype-table.sql
CREATE TABLE IF NOT EXISTS trainingtype (
    trainingtypeid SERIAL PRIMARY KEY,
    trainingname VARCHAR(255) NOT NULL,
    expiretime VARCHAR(50) NOT NULL
);

-- Insert initial data
INSERT INTO trainingtype (trainingname, expiretime) 
SELECT 'Avalanche Safety and Helicopter safety training', '1 week'
WHERE NOT EXISTS (
    SELECT 1 FROM trainingtype WHERE trainingname = 'Avalanche Safety and Helicopter safety training'
);
