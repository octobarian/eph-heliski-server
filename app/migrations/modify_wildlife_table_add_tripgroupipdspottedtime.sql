DO $$
BEGIN
    -- Check if tripgroupid column exists before adding
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='wildlife' 
        AND column_name='tripgroupid'
    ) THEN
        ALTER TABLE wildlife
        ADD COLUMN tripgroupid INTEGER REFERENCES trip_groups(trip_group_id);
    END IF;
    
    -- Check if spottedTime column exists before adding
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns 
        WHERE table_name='wildlife' 
        AND column_name='spottedTime'
    ) THEN
        ALTER TABLE wildlife
        ADD COLUMN spottedTime TIMESTAMP;
    END IF;
END $$;
