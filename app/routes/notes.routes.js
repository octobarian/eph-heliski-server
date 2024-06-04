module.exports = app => {
    const notes = require("../controllers/notes.controller.js");

    var router = require("express").Router();

    // Create a new Note
    router.post("/", notes.createNote);

    // Retrieve all Notes
    router.get("/", notes.findAll);

    // Retrieve a single Note with id
    router.get("/:id", notes.findOne);

    // Find a note via tripId
    router.get("/trip/:tripId", notes.getTripNote);

    // Find a note via runId
    router.get("/run/:tripRunId", notes.getTripRunNote);

    // Find a note via tripGroupId
    router.get("/group/:tripGroupId", notes.getTripGroupNote);

    // Update a Note with id
    router.put("/:id", notes.update);

    // Delete a Note with id
    router.delete("/:id", notes.delete);

    app.use('/api/notes', router);
};
