const db = require("../models");
const { Sequelize, Op } = require('sequelize');

//db imports
const Trip = db.trips;
const Staff = db.staffs;
const Helicopter = db.helicopters;
const Shuttle = db.shuttles;

const Person = db.persons;

const TripStaff = db.tripStaff;
const TripClient = db.tripClients;
const TripGroup = db.tripGroups;
const TripShuttle = db.tripShuttles;

const Reservation = db.reservation;
const Job = db.jobs;
const PersonCustomField = db.personCustomFields;
const Beacon = db.beacons; 

const customFieldToReportHeaderMapping = {
    25: "Allergies to RX",
    26: "Allergies to RX",
    27: "Prescriptions",
    28: "Prescriptions",
    29: "Dietary Restriction",
    30: "Medical Condition",
    31: "Dietary Restriction",
    54: "Severity",
    52: "Ski / Snowboard"
};

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
        ],
        order: [['sortingindex','ASC'], ['tripid', 'ASC'], ['tripGroups', 'trip_group_id', 'ASC']]
    })
    .then(trips => {

        trips.forEach((trip, tripIndex) => {
            console.log(`Trip ${tripIndex + 1}:`);
            trip.tripGroups.forEach((group, groupIndex) => {
                console.log(`  Group ${groupIndex + 1}:`);
                group.tripClients.forEach((client, clientIndex) => {
                    const person = client.reservation.person;
                    console.log(`    Client ${clientIndex + 1}: ${person.firstname}`);
                    person.customFields.forEach(cf => {
                        console.log(`      Custom Field: ID=${cf.dataValues.custom_f}, Name=${cf.dataValues.field_na}, Value=${cf.dataValues.field_va}`);
                    });
                });
            });
        });

        // Transform the Sequelize data into the format expected by the report generator
        const reportData = trips.map((trip, tripIndex) => {
            return {
                helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname || 'Unknown'} ${trip.pilot.person.lastname || 'Pilot'}` : 'No pilot',
                heliIndex: tripIndex + 1,
                groups: trip.tripGroups.map((group, groupIndex) => {
                    return {
                        groupId: group.trip_group_id || 'N/A',
                        groupIndex: groupIndex + 1,
                        clients: group.tripClients.map(tc => {
                            const person = tc.reservation.person || {};
                            let hasMedicalField = false;
                            let hasDietaryField = false;
                            let hasRiderType = '';
                            
                            person.customFields.forEach(cf => {
                                const fieldID = cf.dataValues.custom_f;
                                const fieldValue = cf.dataValues.field_va;
                                
                                // Function to check if the field value is meaningful
                                const isMeaningfulValue = (value) => {
                                    if (!value) return false; // Handles null, undefined, and empty string
                                    const lowerValue = value.toLowerCase();
                                    // Check against 'no' and '{}' considering potential whitespace
                                    return lowerValue.trim() !== 'no' && lowerValue.trim() !== '{}';
                                };
                            
                                // Check for medical field presence and non-'No' and not '{}' value
                                if ([30, 25, 26].includes(fieldID) && isMeaningfulValue(fieldValue)) {
                                    hasMedicalField = true;
                                }
                            
                                // Check for dietary field presence and non-'No' and not '{}' value
                                if ([29, 31].includes(fieldID) && isMeaningfulValue(fieldValue)) {
                                    hasDietaryField = true;
                                }
                                // check ski or snowboard
                                if ([52].includes(fieldID) && fieldValue) {
                                    hasRiderType = fieldValue;
                                }
                            });

                            return {
                                firstName: person.firstname || 'Unknown',
                                lastName: person.lastname || 'Client',
                                weight: person.weight || 'N/A',
                                beacon: tc.beacon ? tc.beacon.beaconnumber : 'N/A',
                                medical_fields: hasMedicalField,
                                dietary_fields: hasDietaryField,
                                ridertype: hasRiderType
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
                                        attributes: [['custom_field_option_id', 'custom_f'], ['field_name', 'field_na'], ['field_value', 'field_va']],
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
        ],
        order: [['sortingindex','ASC'], ['tripid', 'ASC'], ['tripGroups', 'trip_group_id', 'ASC']]
    })
    .then(trips => {
        const customFieldToReportHeaderMapping = {
            6: 'Medical Con',
            25: "Allergy RX",
            26: "Allergy RX",
            27: "Prescriptions",
            28: "Prescriptions",
            29: "Diet Restrict",
            30: "Medical Con",
            31: "Diet Restrict",
            54: "Severity",
        };

        const reportData = trips.map((trip, tripIndex) => {
            return {
                helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname} ${trip.pilot.person.lastname}` : 'No pilot',
                heliIndex: tripIndex + 1,
                groups: trip.tripGroups.map((group, groupIndex) => {
                    return {
                        groupId: group.trip_group_id,
                        groupIndex: groupIndex + 1,
                        clients: group.tripClients.map(tc => {
                            const person = tc.reservation.person;

                            const mappedCustomFields = {};
                            person.customFields.forEach(cf => {
                                const header = customFieldToReportHeaderMapping[cf.dataValues.custom_f];
                                let fieldValue = cf.dataValues.field_va;

                                if (header === 'Medical Con' && (fieldValue === 'No Medical Conditions' || fieldValue === '{}')) {
                                    fieldValue = '';
                                }
                                if (header === 'Diet Restrict' && (fieldValue === 'No' || fieldValue === 'No Dietary Restrictions' || fieldValue === '{}')) {
                                    fieldValue = '';
                                }
                                if (header === 'Allergy RX' && (fieldValue.toLowerCase().includes('none') || fieldValue.toLowerCase().includes('no allergies to rx') || fieldValue === '{}')) {
                                    fieldValue = '';
                                }
                                if (header === 'Severity' && fieldValue === '{}') {
                                    fieldValue = '';
                                }
                                if (header === 'Prescriptions' && (fieldValue === 'None' || fieldValue === 'No Prescriptions' || fieldValue === '{}')) {
                                    fieldValue = '';
                                }

                                if (header && fieldValue) {
                                    mappedCustomFields[header] = (mappedCustomFields[header] || '') + fieldValue + '; ';
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
                })
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



exports.lunchReport = (req, res) => {
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
                attributes: ['callsign'],
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
                                    attributes: ['firstname', 'lastname', 'personid'],
                                    include: [{
                                        model: PersonCustomField,
                                        as: 'customFields',
                                        where: {
                                            custom_field_option_id: {
                                                [Op.in]: [29, 31, 55] // IDs for dietary info
                                            }
                                        },
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
        // Ensure trips and groups are sorted
        const sortedTrips = trips.sort((a, b) => a.sortingindex - b.sortingindex || a.tripid - b.tripid);
        const reportData = sortedTrips.map((trip, tripIndex) => {
            const sortedGroups = trip.tripGroups.sort((a, b) => a.trip_group_id - b.trip_group_id);
            return {
                helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname} ${trip.pilot.person.lastname}` : 'No pilot',
                heliIndex: tripIndex + 1,
                groups: sortedGroups.map((group, groupIndex) => {
                    return {
                        groupId: group.trip_group_id,
                        groupIndex: groupIndex + 1,
                        clients: group.tripClients.map(tc => {
                            const person = tc.reservation.person;
                            const dietaryInfo = {
                                dietaryRestrictions: '',
                                cannotEat: '',
                                severity: ''
                            };

                            const isNonMeaningfulValue = (value) => {
                                return !value || value.toLowerCase() === 'no' || value === '{}';
                            };

                            person.customFields.forEach(cf => {
                                let fieldValue = cf.dataValues.field_va;

                                // If the value is 'no' or an empty object, set it to false
                                if (isNonMeaningfulValue(fieldValue)) {
                                    fieldValue = false;
                                }

                                switch (cf.dataValues.custom_f) {
                                    case 31: // I have special dietary requests or food preferences
                                        dietaryInfo.dietaryRestrictions = fieldValue;
                                        break;
                                    case 29: // I cannot, or prefer not to, eat the following
                                        dietaryInfo.cannotEat = fieldValue;
                                        break;
                                    case 55: // The severity of my dietary request is
                                        dietaryInfo.severity = fieldValue;
                                        break;
                                }
                            });

                            return {
                                firstName: person.firstname,
                                lastName: person.lastname,
                                dietaryRestrictions: dietaryInfo.dietaryRestrictions,
                                cannotEat: dietaryInfo.cannotEat,
                                severity: dietaryInfo.severity
                            };
                        }),
                    };
                }),
            };
        });

        res.json(reportData);
    }).catch(err => {
        console.error("Error occurred while retrieving trips for report:", err);
        res.status(500).send({
            message: "An error occurred while trying to fetch trips for the report.",
            errorDetails: err.message,
        });
    });
};


exports.dailyShuttleReport = async (req, res) => {
    const date = req.query.date || new Date().toISOString().slice(0, 10);

    try {
        const trips = await Trip.findAll({
            where: {
                [Op.and]: [
                    { start_date: { [Op.lte]: date } },
                    { end_date: { [Op.gte]: date } }
                ]
            },
            include: [
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
                                        attributes: ['firstname', 'lastname', 'mobilephone', 'email'],
                                    }],
                                    attributes: ['reservationid']
                                },
                                {
                                    model: TripShuttle,
                                    as: 'tripShuttles',
                                    include: {
                                        model: Shuttle,
                                        as: 'shuttle',
                                        attributes: ['shuttlename']
                                    }
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
                                attributes: ['firstname', 'lastname'],
                            },
                            attributes: ['staffid']
                        }
                    ],
                    attributes: ['trip_group_id', 'start_date', 'end_date']
                },
                {
                    model: Helicopter,
                    as: 'helicopter',
                    attributes: ['callsign']
                },
                {
                    model: Staff,
                    as: 'pilot',
                    include: {
                        model: Person,
                        as: 'person',
                        attributes: ['firstname', 'lastname'],
                    },
                    attributes: ['staffid']
                },
            ],
            order: [['sortingindex','ASC'], ['tripid', 'ASC'], ['tripGroups', 'trip_group_id', 'ASC']]
        });

        // Ensure trips and groups are sorted
        const sortedTrips = trips.sort((a, b) => a.sortingindex - b.sortingindex || a.tripid - b.tripid);
        const sortedReportData = sortedTrips.flatMap((trip, tripIndex) => {
            const sortedGroups = trip.tripGroups.sort((a, b) => a.trip_group_id - b.trip_group_id);
            return sortedGroups.flatMap((group, groupIndex) =>
                group.tripClients.map(client => {
                    const tripShuttle = client.tripShuttles[0];
                    return {
                        firstname: client.reservation.person.firstname,
                        lastname: client.reservation.person.lastname,
                        phone: client.reservation.person.mobilephone,
                        email: client.reservation.person.email,
                        heliIndex: tripIndex + 1,
                        groupIndex: groupIndex + 1,
                        shuttleName: tripShuttle ? tripShuttle.shuttle.shuttlename : 'Drive Self',
                        dropoff_location: tripShuttle ? tripShuttle.dropoff_location : 'N/A',
                        arrival_time: tripShuttle ? tripShuttle.arrival_time : 'N/A',
                        flight_time: tripShuttle ? tripShuttle.flight_time : 'N/A',
                        pickup_location: tripShuttle ? tripShuttle.pickup_location : 'N/A'
                    };
                })
            );
        });

        res.json(sortedReportData);
    } catch (error) {
        console.error("Error fetching shuttle data:", error);
        res.status(500).send({ message: "Error fetching shuttle data." });
    }
};


exports.groupListReport = (req, res) => {
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
                    attributes: ['firstname', 'lastname'],
                },
                attributes: ['staffid'],
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
                                include: [{
                                    model: Person,
                                    as: 'person',
                                    attributes: ['firstname', 'lastname', 'weight', 'personid'],
                                    include: [{
                                        model: PersonCustomField,
                                        as: 'customFields',
                                        attributes: [['custom_field_option_id', 'custom_f'], ['field_name', 'field_na'], ['field_value', 'field_va']],
                                        required: false
                                    }]
                                }],
                                attributes: ['reservationid']
                            },
                            {
                                model: Beacon,
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
                            as: 'person',
                            attributes: ['firstname', 'lastname'],
                        },
                        attributes: ['staffid'],
                    }
                ],
                attributes: ['trip_group_id', 'start_date', 'end_date']
            },
        ],
        order: [['sortingindex','ASC'], ['tripid', 'ASC'], ['tripGroups', 'trip_group_id', 'ASC']]
    })
    .then(trips => {
        const reportData = trips.map((trip, tripIndex) => {
            const sortedGroups = trip.tripGroups.sort((a, b) => a.trip_group_id - b.trip_group_id);
            return {
                helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname} ${trip.pilot.person.lastname}` : 'No pilot',
                heliIndex: tripIndex + 1,
                groups: sortedGroups.map((group, groupIndex) => {
                    //const guide = group.guide ? `${group.guide.person.firstname} ${group.guide.person.lastname}` : 'No guide';
                    const guide = group.guide ? group.guide.person : null;
                    const guideFirstName = guide ? guide.firstname : 'No guide';
                    const guideLastName = guide ? guide.lastname : 'No guide';
                    const guideWeight = guide ? group.guide.person.weight ? group.guide.person.weight.toString() : 'N/A' : 'No guide';
                    const clients = group.tripClients.map(tc => {
                        const person = tc.reservation.person;
                        let hasAllergies = false;

                        person.customFields.forEach(cf => {
                            const fieldID = cf.dataValues.custom_f;
                            const fieldValue = cf.dataValues.field_va;

                            const isMeaningfulValue = (value) => {
                                if (!value) return false;
                                const lowerValue = value.toLowerCase();
                                return lowerValue.trim() !== 'no' && lowerValue.trim() !== '{}';
                            };

                            if ([25, 26].includes(fieldID) && isMeaningfulValue(fieldValue)) {
                                hasAllergies = true;
                            }
                        });

                        return {
                            lastName: person.lastname,
                            firstName: person.firstname,
                            weight: person.weight || 'N/A',
                            beaconNumber: tc.beacon ? tc.beacon.beaconnumber : 'N/A',
                            hasAllergies: hasAllergies,
                        };
                    });

                    return {
                        groupIndex: groupIndex + 1,
                        guideFirstName,
                        guideLastName,
                        guideWeight, // separate it first last weight
                        clients,
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

exports.dailyRentalReport = (req, res) => {
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
                    attributes: ['firstname', 'lastname'],
                },
                attributes: ['staffid'],
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
                                include: [{
                                    model: Person,
                                    as: 'person',
                                    attributes: ['firstname', 'lastname', 'weight', 'personid'],
                                    include: [{
                                        model: PersonCustomField,
                                        as: 'customFields',
                                        attributes: [
                                            ['custom_field_option_id', 'custom_f'],
                                            ['field_name', 'field_na'],
                                            ['field_value', 'field_va']
                                        ],
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
            46: 'Rentals',
            42: 'Preferred Ski/Board',
            58: 'Size'
        };

        // Ensure trips and groups are sorted
        var totalski =0;
        var totalboard =0;
        var totalRental =0;
        const sortedTrips = trips.sort((a, b) => a.sortingindex - b.sortingindex || a.tripid - b.tripid);
        const reportData = sortedTrips.map((trip, tripIndex) => {
            const sortedGroups = trip.tripGroups.sort((a, b) => a.trip_group_id - b.trip_group_id);
            return {
                //trip heli start
                helicopterId: trip.helicopter ? trip.helicopter.callsign : 'NONE',
                pilot: trip.pilot && trip.pilot.person ? `${trip.pilot.person.firstname} ${trip.pilot.person.lastname}` : 'No pilot',
                heliIndex: tripIndex + 1,
                groups: sortedGroups.map((group, groupIndex) => {
                    var groupski = 0;
                    var groupboard = 0;
                    return {
                        groupId: group.trip_group_id,
                        groupIndex: groupIndex + 1,
                        clients: group.tripClients.map(tc => {
                            const person = tc.reservation.person;

                            // Map the customFields to the report's expected structure
                            const mappedCustomFields = {};
                            person.customFields.forEach(cf => {
                                const header = customFieldToReportHeaderMapping[cf.dataValues.custom_f];
                                let fieldValue = cf.dataValues.field_va;
                                
                                // Clean up the field values
                                if (header === 'Rentals' && fieldValue === '{}') {
                                    fieldValue = '';
                                }
                                else if(header === 'Rentals' && fieldValue === 'Skis'){
                                    groupski++;
                                }
                                else if(header === 'Rentals' && fieldValue === 'Snowboard'){
                                    groupboard++;
                                }
                                if (header === 'Preferred Ski/Board' && fieldValue === '{}') {
                                    fieldValue = '';
                                }
                                
                                if (header === 'Size' && fieldValue === '{}') {
                                    fieldValue = '';
                                }
                                if (header && fieldValue) {
                                    mappedCustomFields[header] = (mappedCustomFields[header] || '') + fieldValue + '; ';
                                }
                            });
                            totalboard += groupboard;
                            totalski += groupski;

                            return {
                                firstName: person.firstname,
                                lastName: person.lastname,
                                rentals: mappedCustomFields['Rentals'] || 'No Rentals',
                                preferredSkiBoard: mappedCustomFields['Preferred Ski/Board'] || 'N/A',
                                size: mappedCustomFields['Size'] || 'N/A',
                            };
                        }),
                        groupski: groupski,
                        groupboard: groupboard,
                        totalGroupRentals: groupski+groupboard,
                    };
                }),
                totalski: totalski,
                totalboard: totalboard,
                totalRental: totalski+totalboard,
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

