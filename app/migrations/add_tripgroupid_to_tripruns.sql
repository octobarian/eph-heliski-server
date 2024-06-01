DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='tripruns' 
        AND column_name='trip_group_id'
    ) THEN
        ALTER TABLE tripruns
        ADD COLUMN trip_group_id INTEGER REFERENCES trip_groups(trip_group_id);
    END IF;
END $$;
