-- add_triptype_to_trips.sql
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='trips' 
        AND column_name='triptype'
    ) THEN
        ALTER TABLE trips
        ADD COLUMN triptype VARCHAR(255);
    END IF;
END $$;
