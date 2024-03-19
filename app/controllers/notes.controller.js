const db = require("../models");
const Note = db.notes;
const Trip = db.trips

// Create and Save a new Note
exports.createNote = (req, res) => {
    // Validate request
    if (!req.body.text || !req.body.personid || !req.body.type || !req.body.itemid) {
        res.status(400).send({
            message: "Content, person ID, type, and item ID cannot be empty!"
        });
        return;
    }

    // Create a Note
    const note = {
        personid: req.body.personid,
        text: req.body.text
    };

    // Save Note in the database
    Note.create(note)
        .then(data => {
            // Handle different types of notes
            switch (req.body.type) {
                case 'tripnote':
                    // Link the created note to the trip
                    return Trip.update({ noteid: data.noteid }, { where: { tripid: req.body.itemid } })
                        .then(() => {
                            return data; // Return the note data after linking it
                        });
                case 'beaconnote':
                    // Future implementation for beacon note
                    break;
                case 'helinote':
                    // Future implementation for helicopter note
                    break;
                case 'staffnote':
                    // Future implementation for staff note
                    break;
                case 'clientnote':
                    // Future implementation for client note
                    break;
                default:
                    throw new Error("Invalid note type");
            }
        })
        .then((noteData) => {
            res.send(noteData); // Send the created note data as response
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while creating the Note."
            });
        });
};



// Retrieve all Notes from the database.
exports.findAll = (req, res) => {
    Note.findAll()
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while retrieving notes."
            });
        });
};

// Find a single Note with an id
exports.findOne = (req, res) => {
    const id = req.params.id;

    Note.findByPk(id)
        .then(data => {
            if (data) {
                res.send(data);
            } else {
                res.status(404).send({
                    message: `Cannot find Note with id=${id}.`
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error retrieving Note with id=" + id
            });
        });
};

// Retrieve a note associated with a given trip ID
exports.getTripNote = (req, res) => {
    const tripId = req.params.tripId;

    console.log("FOUND TRIPID:"+tripId)
    Trip.findByPk(tripId, {
        include: [{
            model: Note,
            as: 'note'
        }]
    })
    .then(trip => {
        if (trip && trip.note) {
            res.send(trip.note);
        } else {
            res.status(404).send({
                message: `No note found for trip ID ${tripId}.`
            });
        }
    })
    .catch(err => {
        res.status(500).send({
            message: "Error retrieving note for trip ID " + tripId
        });
    });
};

// Update a Note by the id in the request
exports.update = (req, res) => {
    const id = req.params.id;

    Note.update(req.body, {
        where: { noteid: id }
    })
        .then(num => {
            if (num == 1) {
                res.send({
                    message: "Note was updated successfully."
                });
            } else {
                res.send({
                    message: `Cannot update Note with id=${id}. Maybe Note was not found or req.body is empty!`
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error updating Note with id=" + id
            });
        });
};

// Delete a Note with the specified id in the request
exports.delete = (req, res) => {
    const id = req.params.id;

    Note.destroy({
        where: { noteid: id }
    })
        .then(num => {
            if (num == 1) {
                res.send({
                    message: "Note was deleted successfully!"
                });
            } else {
                res.send({
                    message: `Cannot delete Note with id=${id}. Maybe Note was not found!`
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Could not delete Note with id=" + id
            });
        });
};
