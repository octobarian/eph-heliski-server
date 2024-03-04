const db = require("../models");
const Reservation = db.reservation;
const Op = db.Sequelize.Op;

// Retrieve all reservations
exports.findAll = (req, res) => {
    Reservation.findAll({
        include: [{
            model: db.persons,
            as: 'person'
        }]
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving reservations."
        });
    });
};

// Retrieve a single reservation by id
exports.findOne = (req, res) => {
    const id = req.params.id;

    Reservation.findByPk(id, {
        include: [
            {
                model: db.persons,
                as: 'person'
            },
            {
                model: db.reservationDetails,
                as: 'details'
            }
        ]
    })
    .then(data => {
        if (data) {
            res.send(data);
        } else {
            res.status(404).send({
                message: `Reservation with id ${id} not found.`
            });
        }
    })
    .catch(err => {
        res.status(500).send({
            message: "Error retrieving Reservation with id=" + id
        });
    });
};

//Search for one or more items based on a query
exports.search = (req, res) => {
    const query = req.query.q;
    const searchConditions = [
        { '$person.firstname$': { [Op.iLike]: `%${query}%` } },
        { '$person.lastname$': { [Op.iLike]: `%${query}%` } },
        { '$person.email$': { [Op.iLike]: `%${query}%` } },
        { groupcode: { [Op.iLike]: `%${query}%` } }
    ];

    // Only add reservationid to the search criteria if the query is a valid integer
    if (!isNaN(query)) {
        searchConditions.push({ reservationid: parseInt(query, 10) });
    }

    Reservation.findAll({
        where: {
            [Op.or]: searchConditions
        },
        include: [{
            model: db.persons,
            as: 'person'
        }]
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        res.status(500).send({
            message: `Error retrieving reservations: ${err.message}`
        });
    });
};


// Find reservations by group code
exports.findByGroupCode = (req, res) => {
    const groupCode = req.query.groupCode;

    Reservation.findAll({
        where: {
            groupcode: groupCode
        },
        include: [{
            model: db.persons,
            as: 'person'
        }]
    })
    .then(data => {
        if (data.length) {
            res.send(data);
        } else {
            res.status(404).send({
                message: `No reservations found with group code ${groupCode}.`
            });
        }
    })
    .catch(err => {
        res.status(500).send({
            message: `Error retrieving reservations with group code ${groupCode}: ${err.message}`
        });
    });
};

exports.findUnassignedByDate = (req, res) => {
    const activityDate = req.params.date;

    db.reservation.findAll({
        where: {
            activitydate: activityDate,
            '$tripClients.reservationid$': null
        },
        include: [
            {
                model: db.persons,
                as: 'person',
                attributes: ['firstname', 'lastname', 'weight', 'email']
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
                attributes: [],
                required: false
            }
        ]
    })
    .then(reservations => {
        const formattedReservations = reservations.map(reservation => {
            const reservationJSON = reservation.toJSON();
            const activityName = reservationJSON.details.length > 0 && reservationJSON.details[0].activity ? reservationJSON.details[0].activity.activityname : 'No Activity Name';
            return {
                ...reservationJSON,
                clientName: reservation.person.firstname + ' ' + reservation.person.lastname,
                weight: reservation.person.weight,
                email: reservation.person.email,
                activityName: activityName,
                reservationDetails: reservationJSON.details // No need to call .toJSON() here
            };
        });

        res.send(formattedReservations);
    })
    .catch(err => {
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving reservations."
        });
    });
};








// Add other methods as needed
