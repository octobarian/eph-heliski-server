CREATE TABLE IF NOT EXISTS trip_shuttles (
    id SERIAL PRIMARY KEY,
    trip_id INTEGER REFERENCES trips(tripid) ON DELETE CASCADE,
    shuttle_id INTEGER REFERENCES shuttles(id) ON DELETE CASCADE,
    tripclientid INTEGER REFERENCES trip_clients(tripclientid) ON DELETE CASCADE,
    dropoff_location VARCHAR(255),
    arrival_time TIME,
    flight_time TIME,
    pickup_location VARCHAR(255)
);
