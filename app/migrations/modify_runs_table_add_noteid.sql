DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='trip_groups' 
        AND column_name='noteid'
    ) THEN
        ALTER TABLE trip_groups
        ADD COLUMN noteid INTEGER REFERENCES notes(noteid);
    END IF;
END $$;
