const db = require("../models");
const { Sequelize, Op } = require('sequelize');

//db imports
const Trip = db.trips;
const Staff = db.staffs;
const Helicopter = db.helicopters;
const Person = db.persons;
const PersonTraining = db.persontraining;
const TrainingType = db.trainingtype;
const TripStaff = db.tripStaff;
const TripClient = db.tripClients;
const TripGroup = db.tripGroups;
const Reservation = db.reservation;
const Job = db.jobs;
const TripShuttle = db.tripShuttles;
const Note = db.notes;

//util imports
const { translatePersonIdToClientId } = require('../utility/clientPersonTranslation'); // Update the path according to your project structure

function calculateAge(dateOfBirthString) {
    const birthday = new Date(dateOfBirthString);
    const today = new Date();
    let age = today.getFullYear() - birthday.getFullYear();
    const monthDifference = today.getMonth() - birthday.getMonth();
    if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < birthday.getDate())) {
        age--; // Subtract one year if the birthday has not occurred this year
    }
    return age;
}

// Add models and associations as needed, similar to staff.controller.js


//Delete a trip by its ID
exports.delete = async (req, res) => {
    const id = req.params.id;

    try {
        const transaction = await db.sequelize.transaction();

        // Retrieve all groups attached to this trip
        const groups = await TripGroup.findAll({
            where: { trip_id: id },
            transaction
        });

        // If groups are found, call the deleteGroupById function for each group
        if (groups && groups.length > 0) {
            for (let group of groups) {
                await deleteGroupById(group.groupid, transaction);
            }
        }

        // Delete all entries in the TripStaff table associated with this trip
        await TripStaff.destroy({
            where: { tripid: id },
            transaction
        });

        // Delete all entries in the TripClient table associated with this trip
        await TripClient.destroy({
            where: { tripid: id },
            transaction
        });

        // Delete the trip itself
        const num = await Trip.destroy({
            where: { tripid: id },
            transaction
        });

        if (num === 1) {
            await transaction.commit();
            res.send({ message: "Trip was deleted successfully!" });
        } else {
            await transaction.rollback();
            res.status(404).send({ message: `Cannot delete Trip with id=${id}. Maybe Trip was not found!` });
        }
    } catch (error) {
        console.error("Error during transaction:", error.message);
        res.status(500).send({ message: "Could not delete Trip with id=" + id });
    }
};

// Create and Save a new Trip
exports.create = (req, res) => {
    // Validate request
    if (!req.body.date) {
        res.status(400).send({
            message: "Date can not be empty!"
        });
        return;
    }

    // Create a Trip with default properties
    const trip = {
        date: req.body.date,
        start_date: req.body.date, 
        end_date: req.body.date,
        pilotid: null,
        totalvertical: null,
        helicopterid: null,
        // Add default properties for guides and any other expected fields
        guides: [], // Assuming guides is an array of guide IDs
        reservationPersons: [],
    };

    // Save Trip in the database
    Trip.create(trip)
        .then(data => {
            // Include default properties in the response if they are not already present
            const tripResponse = {
                ...data.toJSON(),
                guides: [], // Ensure guides is an array even if it's empty
                reservationPersons: [],
                // ... include other default properties
            };
            console.log(tripResponse);
            res.send(tripResponse);
        })
        .catch(err => {
            console.error("Error: ", err);
            res.status(500).send({
                message: err.message || "Some error occurred while creating the Trip."
            });
        });
};

exports.updateTrip = async (req, res) => {
    const tripId = req.params.id;
    let { pilotid, helicopterid, start_date, end_date, triptype, sortingindex } = req.body;

    // Check if pilotid or helicopterid are undefined or empty and set them to null
    pilotid = pilotid ? pilotid : null;
    helicopterid = helicopterid ? helicopterid : null;

    // Prepare the update object
    let updateObj = { pilotid, helicopterid };

    // Conditionally add start_date, end_date, triptype, and sortingIndex to the update object if they are provided
    if (start_date) updateObj.start_date = start_date;
    if (end_date) updateObj.end_date = end_date;
    if (triptype) updateObj.triptype = triptype;
    if (sortingindex !== undefined) updateObj.sortingindex = sortingindex;

    console.log("Updating trip ID:", tripId, "  Pilot ID:", pilotid, "  Helicopter ID:", helicopterid, "  Start Date:", start_date, "  End Date:", end_date, "  Trip Type:", triptype, "  Sorting Index:", sortingindex);

    try {
        // Start a transaction
        const transaction = await db.sequelize.transaction();
        try {
            // Update the trip details with the update object
            const result = await Trip.update(updateObj, {
                where: { tripid: tripId },
                transaction: transaction
            });
            // Commit the transaction
            await transaction.commit();
            res.send({ message: "Trip updated successfully." });
        } catch (error) {
            // Rollback the transaction in case of an error
            await transaction.rollback();
            console.error("Error during transaction:", error);
            res.status(500).send({
                message: "Error updating trip with id=" + tripId + ". Details: " + error.message
            });
        }
    } catch (error) {
        console.error("Error initiating transaction for trip update:", error);
        res.status(500).send({
            message: "Error initiating transaction for updating trip with id=" + tripId
        });
    }
};



exports.updateGroupDate = async (req, res) => {
    const { groupId, tripId } = req.params;
    const { end_date } = req.body;

    try {
        // Optionally, verify that the groupId belongs to the provided tripId before updating
        const group = await TripGroup.findByPk(groupId);
        if (!group || group.trip_id !== parseInt(tripId)) {
            return res.status(404).send({ message: "Trip group not found or does not belong to the specified trip." });
        }

        // Update the trip group's end date
        await TripGroup.update({ end_date }, {
            where: { trip_group_id: groupId }
        });

        // Check if the trip's end date needs to be updated
        const trip = await Trip.findByPk(tripId);
        if (new Date(end_date) > new Date(trip.end_date)) {
            await Trip.update({ end_date }, {
                where: { tripid: tripId }
            });
        }

        res.send({ message: "Trip group and, if applicable, trip end date updated successfully." });
    } catch (error) {
        console.error("Error updating trip group end date:", error);
        res.status(500).send({
            message: "An error occurred while trying to update the trip group's end date."
        });
    }
};


// Remove a client from a group (used in Greeting-Office.vue)
exports.removeClientFromGroup = async (req, res) => {
    const { groupId, tripClientId } = req.params;

    try {
        // Start a transaction
        const transaction = await db.sequelize.transaction();

        try {
            // First, set tripclientid to null for any beacons associated with this tripclient
            await db.beacons.update(
                { tripclientid: null },
                {
                    where: { tripclientid: tripClientId },
                    transaction: transaction
                }
            );

            // Then, proceed with deleting the tripclient
            const result = await db.tripClients.destroy({
                where: {
                    trip_group_id: groupId,
                    tripclientid: tripClientId // Adjust the column names to match your schema if necessary
                },
                transaction: transaction
            });

            if (result === 1) {
                // If the delete operation was successful, commit the transaction
                await transaction.commit();
                res.send({
                    message: "Client was removed successfully from the group."
                });
            } else {
                // If no rows were deleted, roll back the transaction
                await transaction.rollback();
                res.send({
                    message: `Cannot remove Client with tripClientId=${tripClientId} from Group with id=${groupId}. Maybe Client was not found!`
                });
            }
        } catch (error) {
            // If any error occurs, roll back the transaction
            await transaction.rollback();
            res.status(500).send({
                message: "Error removing Client with tripClientId=" + tripClientId + " from Group with id=" + groupId
            });
        }
    } catch (error) {
        res.status(500).send({
            message: "Transaction error on removing Client with tripClientId=" + tripClientId + " from Group with id=" + groupId
        });
    }
};


// Fetch guides from the database (jobid 2 for guides)
exports.fetchGuides = (req, res) => {
    Staff.findAll({
        where: { jobid: 2 },
        include: [{
            model: Person,
            as: 'person',
            attributes: ['firstname', 'lastname']
        }]
    })
    .then(guides => {
        res.send(guides);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving guides."
        });
    });
};

exports.updateGroupGuide = async (req, res) => {
    const { groupId } = req.params;
    const { guideId, guideAdditionalId } = req.body;

    console.log(`Trying To Update Group ${groupId} with Guide: ${guideId} and addguide: ${guideAdditionalId}`);
    try {
        const group = await TripGroup.findByPk(groupId);
        if (group) {
            group.guide_id = Array.isArray(guideId) ? guideId[0] || null : guideId;
            group.guide_additional_id = Array.isArray(guideId) ? guideId[1] || null : guideAdditionalId || null;
            await group.save();
            res.send({ message: "Guide(s) updated successfully." });
        } else {
            res.status(404).send({ message: "Group not found." });
        }
    } catch (error) {
        console.error("Error updating guide(s) for group:", error);
        res.status(500).send({ message: "Error updating guide(s) for group." });
    }
};



// Fetch pilots from the database (jobid 1 for pilots)
exports.fetchPilots = (req, res) => {
    Staff.findAll({
        where: { jobid: 1 },
        include: [{
            model: Person,
            as: 'person',
            attributes: ['firstname', 'lastname']
        }]
    })
    .then(pilots => {
        res.send(pilots);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving pilots."
        });
    });
};

// Retrieve all helicopters from the database.
exports.fetchHelicopters = (req, res) => {
    Helicopter.findAll({
        attributes: ['helicopterid', 'fuelamounttotal', 'weight', 'model', 'callsign', 'maxweight']
        // Add any other attributes you need
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving helicopters."
        });
    });
};
exports.findByDate = (req, res) => {
    const date = req.params.date;

    Trip.findAll({
        where: {
            [Op.and]: [
                { start_date: { [Op.lte]: date } },
                { end_date: { [Op.gte]: date } }
            ]
        },
        include: [
            {
                model: Helicopter,
                as: 'helicopter',
                required: false
            },
            {
                model: Staff,
                as: 'pilot',
                include: {
                    model: Person,
                    as: 'person'
                },
                required: false
            },
            {
                model: TripStaff,
                as: 'tripStaff',
                include: {
                    model: Staff,
                    as: 'staff',
                    include: [
                        {
                            model: Person,
                            as: 'person'
                        },
                        {
                            model: Job,
                            as: 'job'
                        }
                    ]
                }
            },
            {
                model: TripGroup,
                as: 'tripGroups',
                required: false,
                where: {
                    [Op.and]: [
                        { start_date: { [Op.lte]: date } },
                        { end_date: { [Op.gte]: date } }
                    ]
                },
                include: [
                    {
                        model: TripClient,
                        as: 'tripClients',
                        include: [
                            {
                                model: Reservation,
                                as: 'reservation',
                                include: [
                                    {
                                        model: Person,
                                        as: 'person',
                                        attributes: ['firstname', 'lastname', 'weight', 'personid', 'dateofbirth'],
                                        include: [
                                            {
                                                model: PersonTraining,
                                                as: 'trainings'
                                            }
                                        ]
                                    }
                                ],
                                attributes: ['reservationid'],
                            },
                            {
                                model: db.beacons,
                                as: 'beacon',
                                attributes: ['beaconid', 'beaconnumber'],
                                where: { active: true },
                                required: false
                            }
                        ],
                        attributes: ['tripclientid']
                    },
                    {
                        model: Staff,
                        as: 'guide',
                        include: {
                            model: Person,
                            as: 'person'
                        }
                    },
                    {
                        model: Staff,
                        as: 'guideAdditional',
                        include: {
                            model: Person,
                            as: 'person'
                        }
                    },
                    {
                        model: Note,
                        as: 'note'
                    }
                ],
                attributes: ['trip_group_id', 'start_date', 'end_date']
            },
        ],
        attributes: ['tripid', 'sortingindex', 'date', 'start_date', 'end_date', 'totalvertical', 'triptype', 'pilotid', 'helicopterid'],
        order: [
            ['sortingindex', 'ASC'],
            ['tripid', 'ASC'],
            [{ model: TripGroup, as: 'tripGroups' }, 'trip_group_id', 'ASC']
        ]
    })
    .then(data => {
        const formattedData = data.map(trip => {
            const pilot = trip.pilot ? {
                staffid: trip.pilotid,
                firstname: trip.pilot.person.firstname,
                lastname: trip.pilot.person.lastname
            } : null;

            const helicopter = trip.helicopter ? {
                helicopterid: trip.helicopterid,
                model: trip.helicopter.model,
                callsign: trip.helicopter.callsign
            } : null;

            const groups = trip.tripGroups.map(group => {
                const guide = group.guide ? {
                    guideid: group.guide.staffid,
                    firstname: group.guide.person.firstname,
                    lastname: group.guide.person.lastname
                } : null;

                const guideAdditional = group.guideAdditional ? {
                    guideid: group.guideAdditional.staffid,
                    firstname: group.guideAdditional.person.firstname,
                    lastname: group.guideAdditional.person.lastname
                } : null;

                const clients = group.tripClients.map(client => {
                    const hasReservation = !!client.reservation;

                    const trainings = hasReservation ? client.reservation.person.trainings.map(training => {
                        const trainingData = training.dataValues;
                        return {
                            trainingtypeid: trainingData.trainingtyp || trainingData.trainingtypeid || null,
                            trainingdate: trainingData.trainingdat || trainingData.trainingdate || null,
                        };
                    }) : [];

                    return {
                        tripClientId: client.tripclientid,
                        reservationId: hasReservation ? client.reservation.reservationid : null,
                        person: hasReservation ? {
                            firstname: client.reservation.person.firstname,
                            lastname: client.reservation.person.lastname,
                            weight: client.reservation.person.weight,
                            id: client.reservation.person.personid,
                            age: calculateAge(client.reservation.person.dateofbirth),
                            trainings: trainings
                        } : null,
                        beacon: client.beacon ? {
                            beaconid: client.beacon.beaconid,
                            beaconnumber: client.beacon.beaconnumber,
                        } : null
                    };
                });

                return {
                    groupid: group.trip_group_id ? group.trip_group_id : null,
                    start_date: group.start_date,
                    end_date: group.end_date,
                    guide: guide,
                    guideAdditional: guideAdditional,
                    clients: clients,
                    noteContent: group.note ? group.note.text : ''
                };
            });

            return {
                tripId: trip.tripid,
                sortingindex: trip.sortingindex,
                date: trip.date,
                start_date: trip.start_date,
                end_date: trip.end_date,
                totalVertical: trip.totalvertical,
                triptype: trip.triptype,
                pilot: pilot,
                helicopter: helicopter,
                groups: groups
            };
        });
        res.send(formattedData); 
    })
    .catch(err => {
        console.error("Error occurred while retrieving trips:", err);
        console.error("Error Details:", err.message);
        console.error("Stack Trace:", err.stack);

        if (err instanceof Sequelize.EagerLoadingError) {
            console.error("EagerLoadingError: Issue with one of the 'include' statements.");
        }

        res.status(500).send({
            message: "An error occurred while trying to fetch trips.",
            errorDetails: err.message,
        });
    });
};



const calculateFuelPercentage = async (tripGroupId) => {
    try {
        console.log('looking for tripGroup ' + tripGroupId);
        const tripGroup = await TripGroup.findOne({
            where: { trip_group_id: tripGroupId },
            include: [
                {
                    model: TripClient,
                    as: 'tripClients',
                    include: [
                        {
                            model: Reservation,
                            as: 'reservation',
                            include: {
                                model: Person,
                                as: 'person',
                                attributes: ['weight']
                            }
                        }
                    ]
                },
                {
                    model: Staff,
                    as: 'guide',
                    include: {
                        model: Person,
                        as: 'person',
                        attributes: ['weight']
                    }
                }
            ]
        });

        if (!tripGroup) {
            throw new Error(`Trip Group with ID ${tripGroupId} not found`);
        }

        const trip = await Trip.findOne({
            where: { tripid: tripGroup.trip_id },
            include: [
                {
                    model: Helicopter,
                    as: 'helicopter',
                    attributes: ['maxweight', 'weight']
                },
                {
                    model: Staff,
                    as: 'pilot',
                    include: {
                        model: Person,
                        as: 'person',
                        attributes: ['weight']
                    }
                }
            ]
        });

        if (!trip) {
            throw new Error(`Trip with ID ${tripGroup.trip_id} not found`);
        }

        const helicopter = trip.helicopter;
        const pilot = trip.pilot.person;
        const guide = tripGroup.guide ? tripGroup.guide.person : { weight: 0 }; // Default to 0 if no guide

        // Calculate total guest weight
        const guestWeight = tripGroup.tripClients.reduce((total, client) => {
            const personWeight = client.reservation && client.reservation.person ? client.reservation.person.weight : 0;
            return total + (parseFloat(personWeight) || 0);
        }, 0);

        const grossWeight = parseFloat(helicopter.maxweight);
        const emptyWeight = parseFloat(helicopter.weight);
        const pilotWeight = parseFloat(pilot.weight) || 0;
        const rescueGearLunchWeight = 152;
        const guideGuestWeight = (parseFloat(guide.weight) || 0) + guestWeight;

        const usefulLoad = grossWeight - emptyWeight - pilotWeight - rescueGearLunchWeight - guideGuestWeight;
        const fuelPercentage = usefulLoad / 10;

        console.log('For TripGroupId=' + tripGroupId);
        console.log('grossWeight=' + grossWeight + "  emptyWeight=" + emptyWeight + "  pilotWeight=" + pilotWeight + "  RGLweight=" + rescueGearLunchWeight + "  guideGuestWeight=" + guideGuestWeight);
        console.log('usefulLoad=' + usefulLoad + "  fuelPercentage=" + fuelPercentage);
        return fuelPercentage;
    } catch (error) {
        console.error("Error calculating fuel percentage:", error);
        throw error;
    }
};

exports.getTripGroupFuelPercentage = async (req, res) => {
    const { tripGroupId } = req.params;

    try {
        const fuelPercentage = await calculateFuelPercentage(tripGroupId);
        res.json({ tripGroupId, fuelPercentage });
    } catch (error) {
        res.status(500).send({
            message: "An error occurred while calculating the fuel percentage.",
            errorDetails: error.message,
        });
    }
};





exports.deleteGroup = async (req, res) => {
    const groupId = req.params.groupId;

    try {
        // Start a transaction
        const transaction = await db.sequelize.transaction();

        try {
            // Step 1: Retrieve all TripClients for the group
            const tripClients = await TripClient.findAll({
                where: { trip_group_id: groupId },
                transaction
            });

            // Step 2: For each TripClient, nullify the beacon's tripclientid if it exists
            for (let tripClient of tripClients) {
                await db.beacons.update(
                    { tripclientid: null },
                    {
                        where: { tripclientid: tripClient.tripclientid },
                        transaction
                    }
                );
            }

            // Step 3: Delete all TripClients now that beacons have been detached
            await TripClient.destroy({
                where: { trip_group_id: groupId },
                transaction
            });

            // Finally, delete the TripGroup itself
            await TripGroup.destroy({
                where: { trip_group_id: groupId },
                transaction
            });

            // Commit the transaction
            await transaction.commit();
            res.send({ message: "Group and its clients were deleted successfully!" });
        } catch (error) {
            // Rollback the transaction in case of an error
            await transaction.rollback();
            console.error("Error during group deletion transaction:", error);
            res.status(500).send({
                message: "Could not delete the group with groupId=" + groupId
            });
        }
    } catch (error) {
        console.error("Transaction error on deleting group with groupId=" + groupId, error);
        res.status(500).send({
            message: "Transaction error on deleting group with groupId=" + groupId
        });
    }
};

async function deleteGroupById(groupId, transaction) {
    // Group deletion logic extracted from the original deleteGroup function
    const tripClients = await TripClient.findAll({
        where: { trip_group_id: groupId },
        transaction
    });

    for (let tripClient of tripClients) {
        await db.beacons.update(
            { tripclientid: null },
            { where: { tripclientid: tripClient.tripclientid }, transaction }
        );
    }

    await TripClient.destroy({
        where: { trip_group_id: groupId },
        transaction
    });

    await TripGroup.destroy({
        where: { trip_group_id: groupId },
        transaction
    });
}

exports.createGroup = async (req, res) => {
    const tripId = req.params.tripId; // or req.body.tripId depending on how you're passing it

    // Check if tripId is not undefined or null
    if (!tripId) {
        return res.status(400).send({
            message: "Trip ID must be provided."
        });
    }

    try {
        // Find the trip by ID to get the start date
        const trip = await Trip.findByPk(tripId);
        if (!trip) {
            return res.status(404).send({
                message: "Trip not found."
            });
        }

        // Create a new group with the start_date and end_date based on the trip's start_date
        const newGroup = await TripGroup.create({
            trip_id: tripId,
            start_date: trip.start_date,
            end_date: trip.start_date 
        });

        return res.status(201).send(newGroup);
    } catch (error) {
        console.error("Error creating new group:", error);
        return res.status(500).send({
            message: "Error creating new group",
            error: error.message,
        });
    }
};


exports.fetchGroupsForTrip = async (req, res) => {
    const { tripId } = req.params;
  
    try {
      const groups = await TripGroup.findAll({
        where: { trip_id: tripId },
        attributes: ['trip_group_id']
      });
  
      res.send(groups);
    } catch (error) {
      res.status(500).send({
        message: "Error retrieving groups for tripId=" + tripId
      });
    }
  };
  

exports.findByGuideAndDate = (req, res) => {
    const staffId = req.params.staffId;
    const date = req.params.date;

    Trip.findAll({
        where: { date: date },
        include: [
            {
                model: Helicopter,
                as: 'helicopter',
            },
            {
                model: Staff,
                as: 'pilot',
                include: {
                    model: Person,
                    as: 'person'
                }
            },
            {
                model: TripStaff,
                as: 'tripStaff',
                include: {
                    model: Staff,
                    as: 'staff',
                    where: { staffid: staffId }, // Filter by the provided staffId
                    include: [
                        {
                            model: Person,
                            as: 'person'
                        },
                        {
                            model: Job,
                            as: 'job'
                        }
                    ]
                }
            },
            {
                model: db.reservation,
                as: 'reservations',
                include: [
                    {
                        model: db.persons,
                        as: 'person',
                        attributes: ['firstname', 'lastname', 'weight']
                    },
                    {
                        model: db.reservationDetails,
                        as: 'details',
                        include: [{
                            model: db.activities,
                            as: 'activity',
                            attributes: ['activityname']
                        }]
                    },
                    {
                        model: db.tripClients,
                        as: 'tripClients',
                        attributes: ['tripclientid']
                    }
                ],
                attributes: ['reservationid'],
                through: { attributes: [] } 
            }
        ]
    })
    .then(data => {
        const formattedData = data.map(trip => {
            const guides = trip.tripStaff
                .filter(staffMember => staffMember.staff && staffMember.staff.job && staffMember.staff.job.jobid === 2)
                .map(staffMember => staffMember.staff.person);

            const pilot = trip.pilot ? trip.pilot.person : null;

            const reservationids = trip.reservations.map(reservation => reservation.reservationid);

            const reservationPersons = trip.reservations.map(reservation => {
                const tripClient = reservation.tripClients && reservation.tripClients.length > 0 ? reservation.tripClients[0] : null;
                const activityName = reservation.details.length > 0 && reservation.details[0].activity ? reservation.details[0].activity.activityname : 'No Activity';

                return {
                    reservationid: reservation.reservationid,
                    person: reservation.person,
                    tripclientid: tripClient ? tripClient.tripclientid : null,
                    activityName: activityName // Adding the activity name here
                };
            });

            return {
                ...trip.toJSON(),
                guides: guides,
                pilot: pilot,
                helicopter: trip.helicopter,
                reservationids: reservationids,
                reservationPersons: reservationPersons
            };
        });

        res.send(formattedData);
    })
    .catch(err => {
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving trips for the guide."
        });
    });
};

exports.assignReservationToTripGroup = async (req, res) => {
    const { tripId, groupId, reservationId, personId} = req.body;

    try {
        const clientId = await translatePersonIdToClientId(personId);
        if (!clientId) {
            return res.status(404).send({ message: "Client not found." });
        }
        try {
        // Logic to link reservation to trip in TripClient table
        await db.tripClients.create({
            tripid: tripId,
            trip_group_id: groupId,
            reservationid: reservationId,
            clientid: clientId
            // clientid can be added if needed
        });

        res.send({ message: "Reservation assigned to trip successfully." });
        } catch (error) {
            console.error(error);
        res.status(500).send({ message: "Error assigning reservation to trip." });
        }
    }
    catch (error) {
        // ... error handling ...
    }
};

exports.removeReservationFromTrip = async (req, res) => {
const { tripId, reservationId } = req.body;

try {
    await db.tripClients.destroy({
    where: {
        tripid: tripId,
        reservationid: reservationId
    }
    });

    res.send({ message: "Reservation removed from trip successfully." });
} catch (error) {
    res.status(500).send({ message: "Error removing reservation from trip." });
}
};

//update the shuttle_trip for a trip
exports.updateGroupShuttle = async (req, res) => {
    const { tripId, groupId, clientId } = req.params;
    const { shuttleNumber, dropoffLocation, arrivalTime, flightTime, pickupLocation } = req.body;

    try {
        if (shuttleNumber === null) {
            // If shuttleNumber is null, delete the trip shuttle entry
            const numDeleted = await TripShuttle.destroy({
                where: {
                    trip_id: tripId,
                    tripclientid: clientId
                }
            });

            if (numDeleted === 1) {
                return res.send({ message: "Trip shuttle details deleted successfully." });
            } else {
                return res.status(404).send({ message: `Trip shuttle details not found for tripId=${tripId}, clientId=${clientId}` });
            }
        }

        // Find or create a trip shuttle entry
        const [tripShuttle, created] = await TripShuttle.findOrCreate({
            where: {
                trip_id: tripId,
                tripclientid: clientId
            },
            defaults: {
                trip_id: tripId,
                shuttle_id: shuttleNumber,
                tripclientid: clientId,
                dropoff_location: dropoffLocation || null,
                arrival_time: arrivalTime || null,
                flight_time: flightTime || null,
                pickup_location: pickupLocation || null
            }
        });

        if (!created) {
            // If it already exists, update the entry
            await tripShuttle.update({
                shuttle_id: shuttleNumber,
                dropoff_location: dropoffLocation || null,
                arrival_time: arrivalTime || null,
                flight_time: flightTime || null,
                pickup_location: pickupLocation || null
            });
        }

        res.send({ message: "Trip shuttle details updated successfully.", tripShuttle });
    } catch (error) {
        console.error("Error updating trip shuttle details:", error);
        res.status(500).send({ message: "Error updating trip shuttle details." });
    }
};


exports.fetchTripShuttles = async (req, res) => {
    const { tripIds, clientIds } = req.body;

    try {
        const tripShuttles = await TripShuttle.findAll({
            where: {
                trip_id: tripIds,
                tripclientid: clientIds
            }
        });

        res.send(tripShuttles);
    } catch (error) {
        console.error("Error fetching trip shuttles:", error);
        res.status(500).send({ message: "Error fetching trip shuttles." });
    }
};

exports.updateTraining = async (req, res) => {
    try {
        const { personid, trainingtypeid, trainingdate } = req.body;

        // Check if the person is already trained with the specified training type
        const existingTraining = await PersonTraining.findOne({
            where: {
                personid: personid,
                trainingtypeid: trainingtypeid
            }
        });

        if (existingTraining) {
            if (trainingdate === null) {
                // Delete the existing training entry if trainingdate is null
                await existingTraining.destroy();
                return res.status(200).send({ message: "Training removed successfully." });
            } else {
                // Update the existing training entry with the new date
                existingTraining.trainingdate = trainingdate;
                await existingTraining.save();
                return res.status(200).send(existingTraining);
            }
        }

        // Create a new training entry if no existing training was found and trainingdate is not null
        if (trainingdate !== null) {
            const newTraining = await PersonTraining.create({
                personid: personid,
                trainingtypeid: trainingtypeid,
                trainingdate: trainingdate,
                trainingfor: 'Alpine',
                isplaceholder: false
            });
            return res.status(201).send(newTraining);
        }

        res.status(400).send({ message: "Training date is required to add new training." });
    } catch (error) {
        console.error("Error occurred while updating training:", error);
        res.status(500).send({
            message: "An error occurred while updating training.",
            errorDetails: error.message
        });
    }
};


// Other existing or needed endpoints for trips
