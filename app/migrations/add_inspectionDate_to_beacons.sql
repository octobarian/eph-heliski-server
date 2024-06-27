DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='beacons' AND column_name='inspectiondate') THEN
        ALTER TABLE beacons ADD COLUMN inspectiondate DATE;
    END IF;
END $$;
