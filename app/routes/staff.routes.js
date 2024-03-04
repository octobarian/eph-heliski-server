module.exports = app => {
    const staff = require("../controllers/staff.controller.js");

    var router = require("express").Router();

    // Create a new Staff
    router.post("/", staff.create);

    // Retrieve all Staff members
    router.get("/", staff.findAll);

    // Retrieve a single Staff member with id
    router.get("/id/:id", staff.findOne);

    //update a single staff
    router.put("/id/:id", staff.update);

    // Delete a Staff member with id
    router.delete("/id/:id", staff.delete);

    // Delete all Staff members
    // router.delete("/", staff.deleteAll);

    // Additional staff routes can be added here as needed
    router.get("/jobs", staff.fetchJobs);

    router.get("/job/:jobId", staff.findAllByJobId);

    router.get("/email/:email", staff.findByEmail);

    app.use('/api/staff', router);
};
