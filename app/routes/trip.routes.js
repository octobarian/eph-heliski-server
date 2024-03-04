module.exports = app => {
    const trips = require("../controllers/trip.controller.js");

    var router = require("express").Router();

    // Assuming you have or will have these endpoints in your trip controller
    // router.get("/", trips.findAll); // Retrieve all trips
    // router.get("/id/:id", trips.findOne); // Retrieve a single trip with id
    // router.put("/id/:id", trips.update); // Update a trip
    // router.delete("/", trips.deleteAll); // Delete all trips

    router.post("/", trips.create);

    router.delete("/id/:id", trips.delete);

    router.put("/id/:id", trips.updateTrip);

    // Fetch guides
    router.get("/guides", trips.fetchGuides);

    // Fetch pilots
    router.get("/pilots", trips.fetchPilots);

    // Fetch helicopters
    router.get("/helicopters", trips.fetchHelicopters);

    // Retrieve all trips for a specific date
    router.get("/date/:date", trips.findByDate);

    // Retrieve the trip for a guide, based on staffid and the date selected
    router.get('/findByGuideAndDate/:staffId/:date', trips.findByGuideAndDate);

    router.post("/assign", trips.assignReservationToTrip);

    router.post('/removereservation', trips.removeReservationFromTrip);

    app.use('/api/trips', router);
};
