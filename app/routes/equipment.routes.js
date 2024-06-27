module.exports = app => {
    const equipment = require("../controllers/equipment.controller.js");

    var router = require("express").Router();

    // BEACONS
    // Create a new Beacon
    router.post("/beacon", equipment.createBeacon);

    // Retrieve all Beacons
    router.get("/beacon", equipment.findAllBeacons);

    // Retrieve a single Beacon with id
    router.get("/beacon/:id", equipment.findOneBeacon);

    // Delete a Beacon with id
    router.delete("/beacon/:id", equipment.deleteBeacon);

    // Update a Beacon with id
    router.put("/beacon/:id", equipment.updateBeacon);

    // Deactivate a Beacon with id
    router.put("/beacon/deactivate/:id", equipment.deactivateBeacon);

    router.put("/beacon/activate/:id", equipment.activateBeacon);

    // Unlink Beacon from trip
    router.put("/beacon/unlink/:id", equipment.unlinkBeaconFromTrip);

    // Assign a Beacon to a trip client
    router.put("/beacon/assign/:beaconId", equipment.assignBeaconToTripClient);

    // HELICOPTERS
    // Create a new Helicopter
    router.post("/helicopter", equipment.createHelicopter);

    // Retrieve all Helicopters
    router.get("/helicopter", equipment.getHelicopters);

    // Delete a Helicopter with id
    router.delete("/helicopter/:id", equipment.deleteHelicopter);

    // Edit a Helicopter with id
    router.put("/helicopter/:id", equipment.editHelicopter);

    // SHUTTLES
    // Create a new Shuttle
    router.post("/shuttle", equipment.createShuttle);

    // Retrieve all Shuttles
    router.get("/shuttle", equipment.findAllShuttles);

    // Delete a Shuttle with id
    router.delete("/shuttle/:id", equipment.deleteShuttle);

    // Edit a Shuttle with id
    router.put("/shuttle/:id", equipment.editShuttle);

    app.use('/api/equipment', router);
};
