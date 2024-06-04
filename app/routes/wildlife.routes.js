module.exports = app => {
    const wildlife = require("../controllers/wildlife.controller.js");

    var router = require("express").Router();

    // Create a new Wildlife Sighting
    router.post("/", wildlife.create);

    // Retrieve Wildlife Sightings by Date and Trip Group
    router.get("/:date/:tripGroupId", wildlife.getByDateAndTripGroup);

    // Delete a Wildlife Sighting with id
    router.delete("/:id", wildlife.delete);

    app.use('/api/wildlife', router);
};
