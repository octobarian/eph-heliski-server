const db = require("../models");

const Run = db.runs;
const Zone = db.zones;
const TripRun = db.tripruns;

// Get all runs
exports.getAllRuns = async (req, res) => {
    try {
        const runs = await Run.findAll();
        res.send(runs);
    } catch (err) {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving runs."
        });
    }
};

// Get all zones
exports.getAllZones = async (req, res) => {
    try {
        const zones = await Zone.findAll();
        res.send(zones);
    } catch (err) {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving zones."
        });
    }
};

// Get runs by zone ID
exports.getRunsByZone = async (req, res) => {
    try {
        const zoneId = req.params.zoneId;
        const runs = await Run.findAll({ where: { zoneid: zoneId } });
        res.send(runs);
    } catch (err) {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving runs by zone."
        });
    }
};

// Get trip runs by list of trip IDs
exports.getTripRuns = async (req, res) => {
    try {
        const { tripIds } = req.body;
        const tripRuns = await TripRun.findAll({ where: { tripid: tripIds } });
        res.send(tripRuns);
    } catch (err) {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving trip runs."
        });
    }
};

// Create a new run
exports.createRun = async (req, res) => {
    try {
        const { runname, zoneid, runzone, startelevation, endelevation, isplaceholder } = req.body;

        if (!runname) {
            return res.status(400).send({ message: "Run name cannot be empty!" });
        }

        const run = {
            runname,
            zoneid: zoneid || null,
            runzone: runzone || null,
            startelevation: startelevation || null,
            endelevation: endelevation || null,
            isplaceholder: isplaceholder || false
        };

        const newRun = await Run.create(run);
        res.send(newRun);
    } catch (err) {
        res.status(500).send({ message: err.message || "Some error occurred while creating the Run." });
    }
};

// Create a new trip run
exports.addTripRun = async (req, res) => {
    try {
        const { tripid, runid, trip_group_id, numberofguests, isplaceholder } = req.body;

        if (!tripid || !runid) {
            return res.status(400).send({ message: "Trip ID and Run ID cannot be empty!" });
        }

        const tripRun = {
            tripid,
            runid,
            trip_group_id,
            numberofguests: numberofguests || 0,
            isplaceholder: isplaceholder || false
        };

        const newTripRun = await TripRun.create(tripRun);
        res.send(newTripRun);
    } catch (err) {
        res.status(500).send({ message: err.message || "Some error occurred while creating the Trip Run." });
    }
};


// Create a new zone
exports.createZone = async (req, res) => {
    try {
        const { zonename, description } = req.body;
        
        if (!zonename) {
            return res.status(400).send({ message: "Zone name cannot be empty!" });
        }

        const zone = {
            zonename,
            description: description || null
        };

        const newZone = await Zone.create(zone);
        res.send(newZone);
    } catch (err) {
        res.status(500).send({ message: err.message || "Some error occurred while creating the Zone." });
    }
};

// Update a run by ID
exports.updateRun = async (req, res) => {
    try {
        const id = req.params.id;
        const { runname, zoneid, runzone, startelevation, endelevation, isplaceholder } = req.body;

        const num = await Run.update({
            runname,
            zoneid: zoneid || null,
            runzone: runzone || null,
            startelevation: startelevation || null,
            endelevation: endelevation || null,
            isplaceholder: isplaceholder || false
        }, { where: { runid: id } });

        if (num == 1) {
            res.send({ message: "Run was updated successfully." });
        } else {
            res.send({ message: `Cannot update Run with id=${id}. Maybe Run was not found or req.body is empty!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error updating Run with id=" + id });
    }
};

// Update a zone by ID
exports.updateZone = async (req, res) => {
    try {
        const id = req.params.id;
        const { zonename, description } = req.body;
        
        const num = await Zone.update({ 
            zonename,
            description: description || null
        }, { where: { id } });

        if (num == 1) {
            res.send({ message: "Zone was updated successfully." });
        } else {
            res.send({ message: `Cannot update Zone with id=${id}. Maybe Zone was not found or req.body is empty!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Error updating Zone with id=" + id });
    }
};

// Delete a run by ID
// WARNING THIS WILL DELETE ALL TRIPRUNS ASSOCIATED WITH THIS RUN
// THIS IS A HUGE DELETE, MAKE SURE USER KNOWS
exports.deleteRun = async (req, res) => {
    try {
        const id = req.params.id;

        // Delete all tripruns associated with the run
        await TripRun.destroy({ where: { runid: id } });

        // Delete the run
        const num = await Run.destroy({ where: { runid: id } });

        if (num == 1) {
            res.send({ message: "Run was deleted successfully!" });
        } else {
            res.status(404).send({ message: `Cannot delete Run with id=${id}. Maybe Run was not found!` });
        }
    } catch (err) {
        console.error("Error deleting run:", err);
        res.status(500).send({ message: "Could not delete Run with id=" + req.params.id, error: err.message });
    }
};

// Delete a trip run by ID
exports.deleteTripRun = async (req, res) => {
    try {
        const id = req.params.id;
        const num = await TripRun.destroy({ where: { triprunid: id } });

        if (num == 1) {
            res.send({ message: "Trip Run was deleted successfully!" });
        } else {
            res.status(404).send({ message: `Cannot delete Trip Run with id=${id}. Maybe Trip Run was not found!` });
        }
    } catch (err) {
        console.error("Error deleting trip run:", err);
        res.status(500).send({ message: "Could not delete Trip Run with id=" + req.params.id, error: err.message });
    }
};

// Delete a zone by ID
// WARNING THIS WILL CASCADE DELETE ALL RUNS, AND IN TURN ALL TRIPRUNS WITH THIS ZONE
// THIS IS A HUGE DELETE, MAKE SURE USER KNOWS
exports.deleteZone = async (req, res) => {
    try {
        const id = req.params.id;

        // Find all runs associated with the zone
        const runs = await Run.findAll({ where: { zoneid: id } });

        // Delete all tripruns associated with each run
        for (const run of runs) {
            await TripRun.destroy({ where: { runid: run.runid } });
        }

        // Delete all runs associated with the zone
        await Run.destroy({ where: { zoneid: id } });

        // Finally, delete the zone
        const num = await Zone.destroy({ where: { id } });

        if (num == 1) {
            res.send({ message: "Zone was deleted successfully!" });
        } else {
            res.send({ message: `Cannot delete Zone with id=${id}. Maybe Zone was not found!` });
        }
    } catch (err) {
        res.status(500).send({ message: "Could not delete Zone with id=" + id });
    }
};
