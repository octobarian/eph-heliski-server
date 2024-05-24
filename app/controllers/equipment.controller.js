const db = require("../models");

const Beacon = db.beacons;
const TripClient = db.tripClients;
const Client = db.clients;
const Person = db.persons;

exports.findAllBeacons = (req, res) => {
    Beacon.findAll({
        include: [{
            model: TripClient,
            as: 'tripClient',
            include: [{
                model: Client,
                as: 'client',
                include: {
                    model: Person,
                    as: 'person',
                    attributes: ['personid', 'firstname', 'lastname', 'mobilephone', 'email', 'country', 'dateofbirth', 'weight']
                    // Add any other person attributes you need
                },
                attributes: ['clientid']
            }],
            attributes: ['tripclientid'] // Add any other tripclient attributes you need
        }],
        attributes: ['beaconnumber', 'beaconid', 'active', 'tripclientid'] // Add any other beacon attributes you need
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving beacons."
        });
    });
};

exports.findOneBeacon = async (req, res) => {
    try {
        const id = req.params.id;
        const beacon = await Beacon.findByPk(id, {
            include: [
                // Include associated models as needed
            ]
        });

        if (beacon) {
            res.send(beacon);
        } else {
            res.status(404).send({ message: `Beacon with id=${id} not found.` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error retrieving Beacon with id=" + id });
    }
};


exports.createBeacon = async (req, res) => {
    try {
        if (!req.body.beaconNumber) {
            return res.status(400).send({ message: "Beacon number cannot be empty!" });
        }
        console.log('CREATING BEACON');
        console.log(req.body.beaconNumber);

        const beacon = {
            beaconnumber: req.body.beaconNumber,
            active: true,
            tripclientid: null
        };

        const newBeacon = await Beacon.create(beacon);
        res.send(newBeacon);
    } catch (err) {
        res.status(500).send({ message: err.message || "Error occurred while creating the Beacon." });
    }
};

exports.deleteBeacon = async (req, res) => {
    try {
        const id = req.params.id;
        const num = await Beacon.destroy({ where: { beaconid: id } });

        if (num == 1) {
            res.send({ message: "Beacon was deleted successfully!" });
        } else {
            res.send({ message: `Cannot delete Beacon with id=${id}. Maybe Beacon was not found!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Could not delete Beacon with id=" + id });
    }
};

exports.deactivateBeacon = async (req, res) => {
    try {
        const id = req.params.id;
        const num = await Beacon.update({ active: false }, { where: { beaconid: id } });

        if (num == 1) {
            res.send({ message: "Beacon was deactivated successfully!" });
        } else {
            res.send({ message: `Cannot deactivate Beacon with id=${id}. Maybe Beacon was not found!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error deactivating Beacon with id=" + id });
    }
};

exports.activateBeacon = async (req, res) => {
    try {
      const id = req.params.id;
      const num = await Beacon.update({ active: true }, { where: { beaconid: id } });
  
      if (num == 1) {
        res.send({ message: "Beacon was activated successfully!" });
      } else {
        res.send({ message: `Cannot activate Beacon with id=${id}. Maybe Beacon was not found!` });
      }
    } catch (err) {
      res.status(500).send({ message: "Error activating Beacon with id=" + id });
    }
  };
  

exports.unlinkBeaconFromTrip = async (req, res) => {
    try {
        const id = req.params.id;
        const num = await Beacon.update({ tripClientId: null }, { where: { beaconid: id } });

        if (num == 1) {
            res.send({ message: "Beacon was unlinked from trip successfully!" });
        } else {
            res.send({ message: `Cannot unlink Beacon with id=${id}. Maybe Beacon was not found!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error unlinking Beacon with id=" + id });
    }
};

exports.assignBeaconToTripClient = async (req, res) => {
    const { beaconId } = req.params;
    const { tripClientId } = req.body; // Ensure tripClientId is sent in the body

    try {
        // Check if beacon is already assigned
        const beacon = await Beacon.findByPk(beaconId);
        if (!beacon) {
            return res.status(404).send({ message: "Beacon not found." });
        }

        // If beacon is already assigned to a different trip client, handle as needed
        if (beacon.tripclientid && beacon.tripclientid !== tripClientId) {
            // Handle reassignment logic if necessary
            // For now, we'll just overwrite it, but in a real scenario,
            // you would want to confirm this before proceeding.
        }

        // Assign the beacon to the new trip client
        beacon.tripclientid = tripClientId;
        
        const savedBeacon = await beacon.save();

        if(savedBeacon) {
            res.send({ message: "Beacon assigned successfully.", beacon: savedBeacon });
        } else {
            res.status(400).send({ message: "Beacon assignment failed." });
        }
    } catch (error) {
        console.error('Error assigning beacon:', error);
        res.status(500).send({ message: error.message || "Some error occurred while assigning the beacon." });
    }
};


// HELICOPTER ITEMS
const Helicopter = db.helicopters;

exports.createHelicopter = async (req, res) => {
    try {
        const { fuelamounttotal, weight, model, callsign, maxweight } = req.body;
        const helicopter = await Helicopter.create({
            fuelamounttotal,
            weight,
            model,
            callsign,
            maxweight,
        });
        res.send(helicopter);
    } catch (err) {
        res.status(500).send({ message: err.message || "Some error occurred while creating the Helicopter." });
    }
};

exports.deleteHelicopter = async (req, res) => {
    try {
        const id = req.params.id;
        const num = await Helicopter.destroy({ where: { helicopterid: id } });
        if (num == 1) {
            res.send({ message: "Helicopter was deleted successfully!" });
        } else {
            res.send({ message: `Cannot delete Helicopter with id=${id}. Maybe Helicopter was not found!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Could not delete Helicopter with id=" + id });
    }
};

exports.editHelicopter = async (req, res) => {
    try {
        const id = req.params.id;
        const { fuelamounttotal, weight, model, callsign, maxweight } = req.body;
        const num = await Helicopter.update({ 
            fuelamounttotal,
            weight,
            model,
            callsign,
            maxweight,
        }, { where: { helicopterid: id } });

        if (num == 1) {
            res.send({ message: "Helicopter was updated successfully." });
        } else {
            res.send({ message: `Cannot update Helicopter with id=${id}. Maybe Helicopter was not found or req.body is empty!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error updating Helicopter with id=" + id });
    }
};

exports.getHelicopters = async (req, res) => {
    try {
        const helicopters = await Helicopter.findAll();
        res.send(helicopters);
    } catch (err) {
        res.status(500).send({ message: err.message || "Some error occurred while retrieving helicopters." });
    }
};

//Shuttle Equipment

const Shuttle = db.shuttles;

// Find all shuttles
exports.findAllShuttles = async (req, res) => {
    try {
        const shuttles = await Shuttle.findAll();
        res.send(shuttles);
    } catch (err) {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving shuttles."
        });
    }
};

// Find a single shuttle by ID
exports.findOneShuttle = async (req, res) => {
    try {
        const id = req.params.id;
        const shuttle = await Shuttle.findByPk(id);
        
        if (shuttle) {
            res.send(shuttle);
        } else {
            res.status(404).send({ message: `Shuttle with id=${id} not found.` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error retrieving Shuttle with id=" + id });
    }
};

// Create a new shuttle
exports.createShuttle = async (req, res) => {
    try {
        const { shuttlename, staffid, description } = req.body;
        
        if (!shuttlename) {
            return res.status(400).send({ message: "Shuttle name cannot be empty!" });
        }

        const shuttle = {
            shuttlename,
            staffid: staffid || null,
            description: description || null
        };

        const newShuttle = await Shuttle.create(shuttle);
        res.send(newShuttle);
    } catch (err) {
        res.status(500).send({ message: err.message || "Some error occurred while creating the Shuttle." });
    }
};

// Delete a shuttle by ID
exports.deleteShuttle = async (req, res) => {
    try {
        const id = req.params.id;
        const num = await Shuttle.destroy({ where: { id } });
        
        if (num == 1) {
            res.send({ message: "Shuttle was deleted successfully!" });
        } else {
            res.send({ message: `Cannot delete Shuttle with id=${id}. Maybe Shuttle was not found!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Could not delete Shuttle with id=" + id });
    }
};

// Update a shuttle by ID
exports.editShuttle = async (req, res) => {
    try {
        const id = req.params.id;
        const { shuttlename, staffid, description } = req.body;
        
        const num = await Shuttle.update({ 
            shuttlename,
            staffid: staffid || null,
            description: description || null
        }, { where: { id } });

        if (num == 1) {
            res.send({ message: "Shuttle was updated successfully." });
        } else {
            res.send({ message: `Cannot update Shuttle with id=${id}. Maybe Shuttle was not found or req.body is empty!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error updating Shuttle with id=" + id });
    }
};

