const db = require("../models");

const Client = db.clients;
const Person = db.persons; // Make sure this matches your Person model name

const PersonHealth = db.personhealth; // Add this line to import the PersonHealth model
const HealthRecordTypes = db.healthrecordtypes; // Add this line to import the HealthRecordTypes model
const HealthRecordValues = db.healthrecordvalues; // Add this line to import the HealthRecordValues model
const HealthSeverities = db.healthseverities; // Add this line to import the HealthSeverities model

const Op = db.Sequelize.Op;

// Create and Save a new Client
exports.create = async (req, res) => {
  // Validate request
  if (!req.body.firstName || !req.body.lastName) {
    res.status(400).send({
      message: "First name and last name can not be empty!"
    });
    return;
  }

  // Create a Person
  const personData = {
    FirstName: req.body.firstName,
    LastName: req.body.lastName,
    MobilePhone: req.body.mobilePhone,
    Email: req.body.email,
    Country: req.body.country,
    DateOfBirth: req.body.dateOfBirth,
    Weight: req.body.weight
  };

  try {
    // Save Person in the database
    const person = await Person.create(personData);

    // Create a Client
    const clientData = {
      PersonID: person.id,
      SkiOrSnowboard: req.body.skiOrSnowboard,
      RidingAbility: req.body.ridingAbility,
      Accommodation: req.body.accommodation
    };

    const client = await Client.create(clientData);
    res.send(client);
  } catch (err) {
    res.status(500).send({
      message: err.message || "Some error occurred while creating the Client."
    });
  }
};

exports.findAll = (req, res) => {
    Client.findAll({
        include: [{
            model: Person,
            as: 'person',
            attributes: ['personid', 'firstname', 'lastname', 'mobilephone', 'email', 'country', 'dateofbirth', 'weight', 'isplaceholder']
        }],
        attributes: ['clientid', 'personid', 'isplaceholder']
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving clients."
        });
    });
};

exports.findOne = (req, res) => {
    const id = req.params.id;

    Client.findByPk(id, {
        include: [
            {
                model: Person,
                as: 'person',
                attributes: ['personid', 'firstname', 'lastname', 'mobilephone', 'email', 'country', 'dateofbirth', 'weight', 'isplaceholder'],
                include: [
                    {
                        model: PersonHealth,
                        as: 'personhealth',
                        include: [
                            {
                                model: HealthRecordValues,
                                as: 'healthrecordvalue',
                                include:[
                                    {
                                        model: HealthRecordTypes,
                                        as: 'healthrecordtype'
                                    },
                                ]
                            },
                            {
                                model: HealthSeverities,
                                as: 'severity'
                            }
                        ],
                        attributes: [
                            'id',
                            'personid',
                            'healthrecordvalueid',
                            'severityid',
                            'isplaceholder',
                            'description'
                        ]
                    }
                ]
            }
        ],
        attributes: ['clientid', 'personid', 'isplaceholder']
    })
    .then(client => {
        if (client) {
            res.send(client);
        } else {
            res.status(404).send({
                message: `Cannot find Client with id=${id}.`
            });
        }
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: `Error retrieving Client with id=${id}`
        });
    });
};


// Find Clients by Name
exports.findByName = (req, res) => {
    const name = req.query.name;
    Client.findAll({
      include: [{
        model: Person,
        as: 'person',
        where: {
          [Op.or]: [
            { firstname: { [Op.iLike]: `%${name}%` } }, // Ensure the field name is lowercase
            { lastname: { [Op.iLike]: `%${name}%` } }   // Ensure the field name is lowercase
          ]
        }
      }]
    })
    .then(data => {
      if (data) {
        res.send(data);
      } else {
        // If no data is found, send an empty array
        res.send([]);
      }
    })
    .catch(err => {
      console.error("Error: ", err);
      // Send back the actual error message for debugging purposes, or log it instead
      res.status(500).send({
        message: "Error retrieving Clients with name=" + name,
        error: err.message
      });
    });
};

  

// Update a Client by the id in the request
exports.update = async (req, res) => {
  const id = req.params.id;
  const { client, healthRecords } = req.body;

  try {
      // Update Person data
      const personUpdate = await Person.update(client, {
          where: { personid: client.personid }
      });

      if (personUpdate == 1) {
          // Update Client data
          const clientUpdate = await Client.update(client, {
              where: { clientid: id }
          });

          if (clientUpdate == 1) {
              // Update each health record
              for (const record of healthRecords) {
                  await PersonHealth.update(record, {
                      where: { id: record.id }
                  });
              }

              // Fetch the updated client and send it back
              const updatedClient = await Client.findByPk(id, {
                  include: [{
                      model: Person,
                      as: 'person',
                      include: [{
                          model: PersonHealth,
                          as: 'personhealth'
                      }]
                  }]
              });
              res.send(updatedClient);
          } else {
              res.send({
                  message: `Cannot update Client with id=${id}. Maybe Client was not found or req.body is empty!`
              });
          }
      } else {
          res.send({
              message: `Cannot update Person with personid=${client.personid}. Maybe Person was not found or req.body is empty!`
          });
      }
  } catch (err) {
      res.status(500).send({
          message: "Error updating Client with id=" + id
      });
  }
};


// Delete a Client with the specified id in the request
exports.delete = (req, res) => {
  // This might need to handle deletion of both Client and associated Person
  const id = req.params.id;

  // Delete logic here...
};

// Delete all Clients from the database.
exports.deleteAll = (req, res) => {
  // This might need to handle deletion of all Clients and associated Persons
  // Delete logic here...
};

exports.fetchSeverities = (req, res) => {
  HealthSeverities.findAll()
      .then(data => {
          res.send(data);
      })
      .catch(err => {
          res.status(500).send({
              message: err.message || "Some error occurred while retrieving health severities."
          });
      });
};

// Find client by person ID
exports.findByPersonId = (req, res) => {
    const personId = req.params.personId;

    Client.findOne({ where: { personid: personId } })
        .then(client => {
            if (client) {
                res.send(client);
            } else {
                res.status(404).send({
                    message: `No client found with person ID ${personId}.`
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error retrieving Client with person ID=" + personId
            });
        });
};

// Add any other controller methods you might need, such as search by name
