DO $$
BEGIN
    IF CURRENT_DATE = '2024-06-05' THEN
        -- Drop the persontraining table if it exists
        EXECUTE 'DROP TABLE IF EXISTS persontraining';

        -- Create the persontraining table
        EXECUTE '
        CREATE TABLE persontraining (
            persontrainingid SERIAL PRIMARY KEY,
            personid INT NOT NULL,
            trainingtypeid INT NOT NULL,
            trainingfor VARCHAR(255) NOT NULL,
            trainingdate DATE NOT NULL,
            notes VARCHAR(255),
            isplaceholder BOOLEAN DEFAULT FALSE,
            CONSTRAINT fk_person FOREIGN KEY (personid) REFERENCES person(personid) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT fk_trainingtype FOREIGN KEY (trainingtypeid) REFERENCES trainingtype(trainingtypeid) ON DELETE CASCADE ON UPDATE CASCADE
        )';

        -- Optional: Add sample data to the persontraining table
        -- EXECUTE 'INSERT INTO persontraining (personid, trainingtypeid, trainingfor, trainingdate, notes, isplaceholder) VALUES (1, 1, ''Sample Training'', ''2024-01-01'', ''Sample Note'', false)';
    END IF;
END $$;
