module.exports = app => {
    const equipment = require("../controllers/equipment.controller.js");

    var router = require("express").Router();

    // Create a new Beacon
    router.post("/beacon", equipment.createBeacon);

    // Retrieve all Beacons
    router.get("/beacon", equipment.findAllBeacons);

    // Retrieve a single Beacon with id
    router.get("/beacon/:id", equipment.findOneBeacon);

    // Delete a Beacon with id
    router.delete("/beacon/:id", equipment.deleteBeacon);

    // Deactivate a Beacon with id
    router.put("/beacon/deactivate/:id", equipment.deactivateBeacon);

    router.put("/beacon/activate/:id", equipment.activateBeacon);

    // Unlink Beacon from trip
    router.put("/beacon/unlink/:id", equipment.unlinkBeaconFromTrip);

    // Assign a Beacon to a trip client
    router.put("/beacon/assign/:beaconId", equipment.assignBeaconToTripClient);


    app.use('/api/equipment', router);
};
