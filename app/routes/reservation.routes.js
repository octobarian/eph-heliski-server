module.exports = app => {
    const reservations = require("../controllers/reservation.controller.js");

    var router = require("express").Router();

    // Retrieve all reservations
    router.get("/", reservations.findAll);

    // Retrieve a single reservation with id
    router.get("/id/:id", reservations.findOne);

    //search based on user query
    router.get("/search", reservations.search);

    router.get("/unassigned/:date", reservations.findUnassignedByDate);

    // Add other routes as needed

    app.use('/api/reservations', router);
};
