DO $$
BEGIN
    -- Check if tripgroupid column exists before adding
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='wildlife' 
        AND column_name='tripgroupid'
    ) THEN
        EXECUTE 'ALTER TABLE wildlife ADD COLUMN tripgroupid INTEGER REFERENCES trip_groups(trip_group_id)';
    END IF;
END $$;

DO $$
BEGIN
    -- Check if spottedTime column exists before adding
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='wildlife' 
        AND column_name='spottedtime'
    ) THEN
        EXECUTE 'ALTER TABLE wildlife ADD COLUMN spottedtime TIMESTAMP';
    END IF;
END $$;
