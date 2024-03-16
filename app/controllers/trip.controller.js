const db = require("../models");

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
    const { pilotid, helicopterid, guideIds } = req.body;

    try {
        // Start a transaction
        const transaction = await db.sequelize.transaction();

        try {
            // Update the trip details
            const result = await db.trips.update(
                { pilotid, helicopterid }, // Assuming these are the only fields to update
                { 
                    where: { tripid: tripId },
                    transaction: transaction
                }
            );

            console.log("Update result:", result);

            // Delete existing guides for this trip
            await db.tripStaff.destroy({
                where: { 
                    tripid: tripId,
                    staffid: guideIds.length > 0 ? { [db.Sequelize.Op.in]: guideIds } : { [db.Sequelize.Op.not]: null } 
                },
                transaction
            });

            // Create new tripStaff entries for guides
            const newGuides = guideIds.map(guideId => ({
                tripid: tripId,
                staffid: guideId // Ensure these are staff IDs
            }));
            await db.tripStaff.bulkCreate(newGuides, { transaction });

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
        res.status(500).send({
            message: "Error initiating transaction for updating trip with id=" + tripId
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

//OLD WORKING FINDBYDATE
// exports.findByDate = (req, res) => {
//     const date = req.params.date;

//     Trip.findAll({
//         where: { date: date },
//         include: [
//             {
//                 model: Helicopter,
//                 as: 'helicopter',
//             },
//             {
//                 model: Staff,
//                 as: 'pilot',
//                 include: {
//                     model: Person,
//                     as: 'person'
//                 }
//             },
//             {
//                 model: TripStaff,
//                 as: 'tripStaff',
//                 include: {
//                     model: Staff,
//                     as: 'staff',
//                     include: [
//                         {
//                             model: Person,
//                             as: 'person'
//                         },
//                         {
//                             model: Job,
//                             as: 'job'
//                         }
//                     ]
//                 }
//             },
//             // Include Reservations associated with the trip
//             {
//                 model: db.reservation,
//                 as: 'reservations',
//                 include: [
//                   {
//                     model: db.persons,
//                     as: 'person',
//                     attributes: ['firstname', 'lastname', 'weight'] // Select only required attributes
//                   }
//                 ],
//                 attributes: ['reservationid'],
//                 through: { attributes: [] } // Exclude the join table attributes
//             }
//         ]
//     })
//     .then(data => {
//         const formattedData = data.map(trip => {
//             // Extract guides, pilot, helicopter, and reservation details
//             // Extract guides from tripStaff
//             const guides = trip.tripStaff
//                 .filter(staffMember => staffMember.staff && staffMember.staff.job && staffMember.staff.job.jobid === 2)
//                 .map(staffMember => staffMember.staff.person);

// //             // Pilot is directly associated with the trip
//             const pilot = trip.pilot ? trip.pilot.person : null;

// //             // Extract reservationids associated with the trip
//             const reservationids = trip.reservations.map(reservation => reservation.reservationid);

//             // Extract reservation details with person info
//             const reservationPersons = trip.reservations.map(reservation => ({
//                 reservationid: reservation.reservationid,
//                 person: reservation.person // This will have firstname, lastname, and weight
//             }));

//             return {
//                 ...trip.toJSON(),
//                 guides: guides,
//                 pilot: pilot,
//                 helicopter: trip.helicopter,
//                 reservationids: reservationids,  // Existing reservation IDs
//                 reservationPersons: reservationPersons // New object with reservation details including person
//             };
//         });

//         res.send(formattedData);
//     })
//     .catch(err => {
//         res.status(500).send({
//             message: err.message || "Some error occurred while retrieving trips."
//         });
//     });
// };

exports.findByDate = (req, res) => {
    const date = req.params.date;

    Trip.findAll({
        where: { date: date },
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
                attributes: ['trip_group_id']
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
                        } : null
                    };
                });
                
                return {
                    groupid: group.trip_group_id?group.trip_group_id:null,
                    guide: guide,
                    clients: clients
                };
            });
    
            return {
                tripId: trip.tripid,
                date: trip.date,
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

// Delete a group and its associated clients
exports.deleteGroup = async (req, res) => {
    const groupId = req.params.groupId;
  
    try {
        // Start a transaction
        const transaction = await db.sequelize.transaction();

        try {
            // Delete associated TripClients first
            await TripClient.destroy({
                where: { trip_group_id: groupId },
                transaction
            });

            // Then, delete the TripGroup
            await TripGroup.destroy({
                where: { trip_group_id: groupId },
                transaction
            });

            // If everything went fine, commit the transaction
            await transaction.commit();
            res.send({
                message: "Group and its clients were deleted successfully!"
            });
        } catch (error) {
            // If an error occurs, rollback the transaction
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



exports.assignReservationToTrip = async (req, res) => {
    const { tripId, reservationId, personId} = req.body;

    try {
        const clientId = await translatePersonIdToClientId(personId);
        if (!clientId) {
            return res.status(404).send({ message: "Client not found." });
        }
        try {
        // Logic to link reservation to trip in TripClient table
        await db.tripClients.create({
            tripid: tripId,
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
