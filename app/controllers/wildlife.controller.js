const db = require("../models");
const Wildlife = db.wildlife;
const Op = db.Sequelize.Op;

// Create and Save a new Wildlife Sighting
exports.create = (req, res) => {
    // Validate request
    if (!req.body.runid || !req.body.type || !req.body.species || !req.body.observerid) {
        res.status(400).send({
            message: "Content can not be empty!"
        });
        return;
    }

    // Create a Wildlife Sighting
    const wildlife = {
        runid: req.body.runid,
        tripgroupid: req.body.tripgroupid,
        type: req.body.type,
        comments: req.body.comments,
        species: req.body.species,
        observerid: req.body.observerid,
        sightingdetails: req.body.sightingdetails,
        isplaceholder: req.body.isplaceholder,
        spottedtime: req.body.spottedTime
    };

    // Save Wildlife Sighting in the database
    Wildlife.create(wildlife)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while creating the Wildlife Sighting."
            });
        });
};

// Retrieve all Wildlife Sightings by Date and Trip Group
exports.getByDateAndTripGroup = (req, res) => {
    const date = req.params.date;
    const tripGroupId = req.params.tripGroupId;

    Wildlife.findAll({
        where: {
            tripgroupid: tripGroupId,
            spottedtime: {
                [Op.between]: [`${date} 00:00:00`, `${date} 23:59:59`]
            }
        }
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving wildlife sightings."
        });
    });
};

// Delete a Wildlife Sighting with the specified id in the request
exports.delete = (req, res) => {
    const id = req.params.id;

    Wildlife.destroy({
        where: { wildlifeid: id }
    })
    .then(num => {
        if (num == 1) {
            res.send({
                message: "Wildlife Sighting was deleted successfully!"
            });
        } else {
            res.send({
                message: `Cannot delete Wildlife Sighting with id=${id}. Maybe Wildlife Sighting was not found!`
            });
        }
    })
    .catch(err => {
        res.status(500).send({
            message: "Could not delete Wildlife Sighting with id=" + id
        });
    });
};
