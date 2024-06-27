DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM job WHERE jobtitle = 'inactive') THEN
        INSERT INTO job (jobtitle) VALUES ('inactive');
    END IF;
END $$;
