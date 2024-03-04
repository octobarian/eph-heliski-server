module.exports = app => {
    const notes = require("../controllers/notes.controller.js");

    var router = require("express").Router();

    // Create a new Note
    router.post("/", notes.createNote);

    // Retrieve all Notes
    router.get("/", notes.findAll);

    // Retrieve a single Note with id
    router.get("/:id", notes.findOne);

    //find a note via tripid
    router.get("/trip/:tripid", notes.getTripNote);

    // Update a Note with id
    router.put("/:id", notes.update);

    // Delete a Note with id
    router.delete("/:id", notes.delete);

    app.use('/api/notes', router);
};
