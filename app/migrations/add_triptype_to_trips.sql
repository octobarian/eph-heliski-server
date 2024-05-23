-- add_triptype_to_trips.sql
ALTER TABLE trips
ADD COLUMN triptype VARCHAR(255);
