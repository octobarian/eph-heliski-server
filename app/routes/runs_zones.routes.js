module.exports = app => {
    const runsZones = require("../controllers/runs_zones.controller.js");

    var router = require("express").Router();

    // Runs
    // Create a new Run
    router.post("/run", runsZones.createRun);

    // Retrieve all Runs
    router.get("/run", runsZones.getAllRuns);

    // Retrieve Runs by Zone
    router.get("/run/by-zone/:zoneId", runsZones.getRunsByZone);

    // Update a Run
    router.put("/run/:id", runsZones.updateRun);

    // Delete a Run
    router.delete("/run/:id", runsZones.deleteRun);

    // Zones
    // Create a new Zone
    router.post("/zone", runsZones.createZone);

    // Retrieve all Zones
    router.get("/zone", runsZones.getAllZones);

    // Update a Zone
    router.put("/zone/:id", runsZones.updateZone);

    // Delete a Zone
    router.delete("/zone/:id", runsZones.deleteZone);

    // Trip Runs
    // Get Trip Runs by List of Trip IDs
    router.post("/triprun/by-trips", runsZones.getTripRuns);

    // Create a new Trip Run
    router.post("/triprun", runsZones.addTripRun);

    // Delete a Trip Run
    router.delete("/triprun/:id", runsZones.deleteTripRun);

    app.use('/api/runs-zones', router);
};
