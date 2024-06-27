-- 20240622_add_sortingIndex_to_trips.sql

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='trips' AND column_name='sortingIndex') THEN
        ALTER TABLE trips ADD COLUMN sortingIndex INTEGER DEFAULT 1;
        UPDATE trips SET sortingIndex = 1 WHERE sortingIndex IS NULL;
    END IF;
END $$;
