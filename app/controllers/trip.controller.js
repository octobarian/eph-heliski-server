const db = require("../models");
const { Sequelize, Op } = require('sequelize');

//db imports
const Trip = db.trips;
const Staff = db.staffs;
const Helicopter = db.helicopters;
const Person = db.persons;
const TripStaff = db.tripStaff;
const TripClient = db.tripClients;
const TripGroup = db.tripGroups;
const Reservation = db.reservation;
const Job = db.jobs;

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

        try {
            // First, delete entries in the TripClient table
            await TripClient.destroy({
                where: { tripid: id },
                transaction
            });

            // Next, delete the trip
            const num = await Trip.destroy({
                where: { tripid: id },
                transaction
            });

            if (num === 1) {
                await transaction.commit();
                res.send({
                    message: "Trip was deleted successfully!"
                });
            } else {
                await transaction.rollback();
                res.status(404).send({
                    message: `Cannot delete Trip with id=${id}. Maybe Trip was not found!`
                });
            }
        } catch (error) {
            console.error("Error during transaction:", error.message);
            await transaction.rollback();
            res.status(500).send({
                message: "Could not delete Trip with id=" + id
            });
        }
    } catch (error) {
        console.error("Transaction error on deleting Trip with id=" + id, error.message); // Log the detailed error
        res.status(500).send({
            message: "Transaction error on deleting Trip with id=" + id
        });
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
    let { pilotid, helicopterid, start_date, end_date } = req.body;

    // Check if pilotid or helicopterid are undefined or empty and set them to null
    pilotid = pilotid ? pilotid : null;
    helicopterid = helicopterid ? helicopterid : null;

    // Prepare the update object
    let updateObj = { pilotid, helicopterid };

    // Conditionally add start_date and end_date to the update object if they are provided
    if (start_date) updateObj.start_date = start_date;
    if (end_date) updateObj.end_date = end_date;

    console.log("Updating trip ID:", tripId, "  Pilot ID:", pilotid, "  Helicopter ID:", helicopterid, "  Start Date:", start_date, "  End Date:", end_date);

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
    const { guideId } = req.body;
    console.log('FOUND GUIDEID: '+guideId);
    console.log('FOUND GROUPID: '+groupId);
  
    try {
      const group = await TripGroup.findByPk(groupId);
      if (group) {
        group.guide_id = guideId;
        await group.save();
        res.send({ message: "Guide updated successfully." });
      } else {
        res.status(404).send({ message: "Group not found." });
      }
    } catch (error) {
      res.status(500).send({ message: "Error updating guide for group." });
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
            //Information contained within a trip: Helicopter, Staff(Pilot), TripStaff->Staff(guide)
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
            //Gather the groups associated to the trip via the trip_group_id
            {
                model: TripGroup, 
                as: 'tripGroups',
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
                                        attributes: ['firstname', 'lastname', 'weight', 'personid', 'dateofbirth'] // Select only required attributes
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
                    }
                ],
                attributes: ['trip_group_id', 'start_date', 'end_date']
            },
        ]
    })
    .then(data => {
        const formattedData = data.map(trip => {
            const pilot = trip.pilot ? {
                staffid: trip.pilotid, // Including pilotid
                firstname: trip.pilot.person.firstname,
                lastname: trip.pilot.person.lastname
            } : null;
    
            const helicopter = trip.helicopter ? {
                helicopterid: trip.helicopterid, // Including helicopterid
                model: trip.helicopter.model,
                callsign: trip.helicopter.callsign
            } : null;
    
            const groups = trip.tripGroups.map(group => {
                const guide = group.guide ? {
                    guideid: group.guide.staffid,
                    firstname: group.guide.person.firstname,
                    lastname: group.guide.person.lastname
                } : null;
    
                const clients = group.tripClients.map(client => {
                    //console.log('Processing client:', client.tripclientid); // Log the trip client ID being processed
                    
                    // Check if client has reservation and person data
                    const hasReservation = !!client.reservation;
                    //console.log(`Client ${client.tripclientid} has reservation:`, hasReservation);
                    
                    if (hasReservation) {
                        //console.log(`Reservation details for client ${client.tripclientid}:`, client.reservation);
                    }
                
                    return {
                        tripClientId: client.tripclientid,
                        reservationId: hasReservation ? client.reservation.reservationid : null,
                        person: hasReservation ? {
                            firstname: client.reservation.person.firstname,
                            lastname: client.reservation.person.lastname,
                            weight: client.reservation.person.weight,
                            id: client.reservation.person.personid,
                            age: calculateAge(client.reservation.person.dateofbirth), 
                        } : null,
                        beacon: client.beacon ? {
                            beaconid: client.beacon.beaconid,
                            beaconnumber: client.beacon.beaconnumber,
                        } : null
                    }; 
                });
                
                console.log("END DATE FOR GROUPL:"+group.end_date);
                return {
                    groupid: group.trip_group_id?group.trip_group_id:null,
                    start_date: group.start_date, 
                    end_date: group.end_date,
                    guide: guide,
                    clients: clients,
                };
            });
    
            return {
                tripId: trip.tripid,
                date: trip.date,
                start_date: trip.start_date, 
                end_date: trip.end_date,
                totalVertical: trip.totalvertical,
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
    
        // If possible, log specific details to help isolate the issue
        if(err instanceof Sequelize.EagerLoadingError) {
            console.error("EagerLoadingError: Issue with one of the 'include' statements.");
        }
    
        res.status(500).send({
            message: "An error occurred while trying to fetch trips.",
            errorDetails: err.message,
        });
    });
    
    
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

exports.createGroup = async (req, res) => {
    const tripId = req.params.tripId; // or req.body.tripId depending on how you're passing it

    // Check if tripId is not undefined or null
    if (!tripId) {
        return res.status(400).send({
            message: "Trip ID must be provided."
        });
    }

    try {
        // Assuming sequelize for ORM
        const newGroup = await TripGroup.create({ trip_id: tripId });
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
// Other existing or needed endpoints for trips
