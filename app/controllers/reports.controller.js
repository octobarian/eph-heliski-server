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
const PersonCustomField = db.personCustomFields;
const Beacon = db.beacons; 

exports.dailyTripsReport = (req, res) => {
    // Get the date from the query parameters, default to today's date if not provided
    const date = req.query.date || new Date().toISOString().slice(0, 10);


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
            },
            {
                model: Staff,
                as: 'pilot',
                include: {
                    model: Person,
                    as: 'person',
                    attributes: ['firstname', 'lastname'] // Include only the name fields
                },
                attributes: ['staffid']
            },
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
                                include: {
                                    model: Person,
                                    as: 'person',
                                    attributes: ['firstname', 'lastname', 'weight', 'personid'], // Include relevant person details
                                    include: [{
                                        model: PersonCustomField,
                                        as: 'customFields',
                                        attributes: ['field_name', 'field_value'],
                                        where: {
                                            [Op.or]: [
                                                { field_name: 'I have a medical condition or past injury that EPH should be aware of:' },
                                                { field_name: 'I have special dietary requests or food preferences:' }
                                            ]
                                        },
                                        required: false
                                    }]
                                },
                                attributes: ['reservationid'] // Include reservation details
                            },
                            {
                                model: Beacon,
                                as: 'beacon',
                                attributes: ['beaconid', 'beaconnumber'], // Include beacon details
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
                            as: 'person',
                            attributes: ['firstname', 'lastname'] // Include only the guide's name
                        },
                        attributes: ['staffid']
                    }
                ],
                attributes: ['trip_group_id', 'start_date', 'end_date'] // Include group details
            },
        ]
    })
    .then(trips => {
        // Transform the Sequelize data into the format expected by the report generator
        const reportData = trips.map(trip => {
            return {
                helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname || 'Unknown'} ${trip.pilot.person.lastname || 'Pilot'}` : 'No pilot',
                groups: trip.tripGroups.map(group => {
                    return {
                        groupId: group.trip_group_id || 'N/A',
                        clients: group.tripClients.map(tc => {
                            const reservation = tc.reservation || {};
                            const person = reservation.person || {};
                            const customFields = person.customFields || [];
                            const medicalFields = customFields
                                .filter(field => field.field_name === 'I have a medical condition or past injury that EPH should be aware of:')
                                .map(field => ({ field_name: field.field_name, field_value: field.field_value }));
                            const dietaryField = customFields
                                .filter(field => field.field_name === 'I have special dietary requests or food preferences:')
                                .map(field => ({ field_name: field.field_name, field_value: field.field_value }));
    
                            return {
                                firstName: person.firstname || 'Unknown',
                                lastName: person.lastname || 'Client',
                                weight: person.weight || 'N/A',
                                beacon: tc.beacon ? tc.beacon.beaconnumber : 'N/A',
                                medical_fields: medicalFields.length > 0 ? medicalFields : [{ field_name: 'Medical', field_value: 'None' }],
                                dietary_field: dietaryField.length > 0 ? dietaryField : [{ field_name: 'Dietary', field_value: 'None' }],
                            };
                        }),
                        fuelPercentage: 35.9 // Placeholder for actual fuel percentage calculation
                    };
                })
                .filter(group => group.clients && group.clients.length > 0)
            };
        })
        // Filter out trips with no groups
        .filter(trip => trip.groups && trip.groups.length > 0);
    
        res.json(reportData);
    })
    .catch(err => {
        console.error("Error occurred while retrieving trips for report:", err);
        res.status(500).send({
            message: "An error occurred while trying to fetch trips for the report.",
            errorDetails: err.message,
        });
    });
};


exports.medicalReport = (req, res) => {
    const date = req.query.date || new Date().toISOString().slice(0, 10);

    Trip.findAll({
        where: {
            [Op.and]: [
                { start_date: { [Op.lte]: date } },
                { end_date: { [Op.gte]: date } }
            ]
        },
        include: [
            // Including helicopter, pilot, and their person details
            {
                model: Helicopter,
                as: 'helicopter',
            },
            {
                model: Staff,
                as: 'pilot',
                include: {
                    model: Person,
                    as: 'person',
                    attributes: ['firstname', 'lastname'],
                },
                attributes: ['staffid'],
            },
            // Including trip groups, trip clients, their reservations, person and custom fields
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
                                include: [{
                                    model: Person,
                                    as: 'person',
                                    attributes: ['firstname', 'lastname', 'weight', 'personid'],
                                    include: [{
                                        model: PersonCustomField,
                                        as: 'customFields',
                                        attributes: [['custom_field_option_id','custom_f'],['field_name', 'field_na'], ['field_value', 'field_va']],
                                        required: false
                                    }]
                                }],
                                attributes: ['reservationid']
                            },
                        ],
                        attributes: ['tripclientid']
                    },
                    {
                        model: Staff,
                        as: 'guide',
                        include: {
                            model: Person,
                            as: 'person',
                            attributes: ['firstname', 'lastname'],
                        },
                        attributes: ['staffid'],
                    }
                ],
                attributes: ['trip_group_id', 'start_date', 'end_date']
            },
        ]
    }).then(trips => {

        const customFieldToReportHeaderMapping = {
            25: "Allergies to RX",
            26: "Allergies to RX",
            27: "Prescriptions",
            28: "Prescriptions",
            29: "Dietary Restriction",
            30: "Medical Condition",
            31: "Dietary Restriction",
            54: "Severity",
            // Assuming 'Severity' relates to the severity of allergies, etc.
          };
          
        // trips.forEach(trip => {
        //     trip.tripGroups.forEach(group => {
        //         group.tripClients.forEach(tc => {
        //             if (tc.reservation && tc.reservation.person) {
        //                 console.log(`CustomFields for ${tc.reservation.person.firstname} ${tc.reservation.person.lastname}:`);
        //                 // Test: Print out the customFields of each person before mapping
        //                 console.log(tc.reservation.person.customFields);
        //             }
        //         });
        //     });
        // });

        const reportData = trips
            .filter(trip => trip.tripGroups.length > 0)
            .map(trip => {
                return {
                    helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                    pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname} ${trip.pilot.person.lastname}` : 'No pilot',
                    groups: trip.tripGroups
                        .filter(group => group.tripClients.length > 0)
                        .map(group => {
                            return {
                                groupId: group.trip_group_id,
                                clients: group.tripClients
                                    .filter(tc => tc.reservation && tc.reservation.person)
                                    .map(tc => {
                                        const person = tc.reservation.person;
                                        
                                        // Map the customFields to the report's expected structure
                                        const mappedCustomFields = {};
                                        person.customFields.forEach(cf => {
                                            const header = customFieldToReportHeaderMapping[cf.dataValues.custom_f];
                                            if (header) {
                                                // Concatenate field values if multiple fields map to the same header
                                                mappedCustomFields[header] = (mappedCustomFields[header] || '') + cf.dataValues.field_va + '; ';
                                            }
                                        });

                                        return {
                                            firstName: person.firstname,
                                            lastName: person.lastname,
                                            weight: person.weight,
                                            beacon: tc.beacon ? tc.beacon.beaconnumber : 'N/A',
                                            customFields: mappedCustomFields,
                                        };
                                    }),
                                fuelPercentage: 35.9 // Placeholder
                            };
                        }),
                };
            });

        res.json(reportData);
    })
    .catch(err => {
        console.error("Error occurred while retrieving trips for report:", err);
        res.status(500).send({
            message: "An error occurred while trying to fetch trips for the report.",
            errorDetails: err.message,
        });
    });
    
};