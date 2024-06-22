const db = require("../models");
const bcrypt = require('bcrypt');
const saltRounds = 10;

const Staff = db.staffs;
const Person = db.persons;
const Job = db.jobs;
const UserLogin = db.user_logins; // Ensure this is imported

exports.create = (req, res) => {
    // Validate request
    if (!req.body.person.email) {
        res.status(400).send({
            message: "Email can not be empty!"
        });
        return;
    }

    // First, create a Person record
    const person = {
        firstname: req.body.person.firstname,
        lastname: req.body.person.lastname,
        email: req.body.person.email,
        // Add other person details here
        // Do not include staffid here since it's the Staff model that should reference Person
    };

    Person.create(person)
        .then(personData => {
            // With the person created, now we can create a Staff record
            const staff = {
                personid: personData.personid, // Use the personid from the newly created Person record
                jobid: req.body.jobid,
                isplaceholder: false, // or however you determine this
            };

            // Save Staff in the database with the personid
            Staff.create(staff)
                .then(staffData => {
                    // Check if canLogin is true
                    if (req.body.canLogin) {
                        const { email, password, role } = req.body.userLogin;

                        // Hash the password
                        bcrypt.hash(password, saltRounds, (err, hash) => {
                            if (err) {
                                res.status(500).send({
                                    message: "Error hashing password."
                                });
                                return;
                            }

                            // Create UserLogin record
                            UserLogin.create({
                                email: email,
                                password_hash: hash,
                                role: role,
                                staff_id: staffData.staffid
                            })
                            .then(userLoginData => {
                                res.send({
                                    staff: staffData,
                                    person: personData,
                                    userLogin: userLoginData
                                });
                            })
                            .catch(err => {
                                res.status(500).send({
                                    message: "Error creating user login.",
                                    error: err.message
                                });
                            });
                        });
                    } else {
                        res.send({
                            staff: staffData,
                            person: personData,
                        });
                    }
                })
                .catch(err => {
                    // If Staff creation failed, optionally delete the Person record
                    res.status(500).send({
                        message: err.message || "Some error occurred while creating the Staff."
                    });
                });
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while creating the Person."
            });
        });
};

// Delete a single Staff member and associated Person
exports.delete = (req, res) => {
    const id = req.params.id;

    // First, find the Staff record to get the associated personid
    Staff.findByPk(id)
        .then(staff => {
            if (!staff) {
                return res.status(404).send({
                    message: `Staff not found with id=${id}`
                });
            }
            const personId = staff.personid;

            // Delete the Staff record
            Staff.destroy({
                where: { staffid: id }
            })
                .then(num => {
                    if (num == 1) {
                        // Now delete the associated Person record
                        Person.destroy({
                            where: { personid: personId }
                        })
                            .then(personNum => {
                                if (personNum == 1) {
                                    res.send({
                                        message: "Staff and associated person were deleted successfully!"
                                    });
                                } else {
                                    res.status(500).send({
                                        message: `Could not delete Person with id=${personId}`
                                    });
                                }
                            })
                            .catch(err => {
                                res.status(500).send({
                                    message: `Error deleting Person with id=${personId}`
                                });
                            });
                    } else {
                        res.status(500).send({
                            message: `Could not delete Staff with id=${id}`
                        });
                    }
                })
                .catch(err => {
                    res.status(500).send({
                        message: `Error deleting Staff with id=${id}`
                    });
                });
        })
        .catch(err => {
            res.status(500).send({
                message: `Error retrieving Staff with id=${id}`
            });
        });
};


// Retrieve all Staff members from the database.
exports.findAll = (req, res) => {
    Staff.findAll({
        include: [{
            model: Person,
            as: 'person',
            attributes: ['personid', 'firstname', 'lastname', 'mobilephone', 'email', 'country', 'dateofbirth', 'weight', 'isplaceholder']
            // Add any other person attributes you need
        },
        // If you have a Job model associated, include it here:
        {
            model: Job,
            as: 'job',
            attributes: ['jobid', 'jobtitle'] // Add any other job attributes you need
        }],
        attributes: ['staffid', 'personid', 'jobid', 'isplaceholder'] // Add any other staff attributes you need
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving staff members."
        });
    });
};

exports.findOne = (req, res) => {
    const id = req.params.id;

    Staff.findByPk(id, {
        include: [
            {
                model: Person,
                as: 'person',
                attributes: ['personid', 'firstname', 'lastname', 'mobilephone', 'email', 'country', 'dateofbirth', 'weight', 'isplaceholder']
            },
            {
                model: Job,
                as: 'job',
                attributes: ['jobid', 'jobtitle'] // Add any other job attributes you need
            },
            {
                model: UserLogin,
                as: 'logins', // Use the correct alias defined in the association
                attributes: ['email', 'role']
            }
        ],
        attributes: ['staffid', 'personid', 'jobid', 'isplaceholder'] // Add any other staff attributes you need
    })
    .then(staff => {
        if (staff) {
            const canLogin = staff.logins.length > 0;
            const role = canLogin ? staff.logins[0].role : 'N/A';
            const loginEmail = canLogin? staff.logins[0].email : ''
            res.send({
                ...staff.toJSON(),
                canLogin,
                role,
                loginEmail
            });
        } else {
            res.status(404).send({
                message: `Cannot find Staff with id=${id}.`
            });
        }
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: `Error retrieving Staff with id=${id}`
        });
    });
};

// Retrieve a single Staff member by email
exports.findByEmail = (req, res) => {
    const email = req.params.email;
    
    Staff.findOne({
      include: [{
        model: Person,
        as: 'person',
        where: { email: email }, // Find where person email matches
        attributes: ['personid', 'firstname', 'lastname', 'email']
      }],
      attributes: ['staffid', 'personid'] // Adjust as needed
    })
    .then(staff => {
      if (staff) {
        res.send(staff);
      } else {
        res.status(404).send({
          message: `Cannot find Staff with email=${email}.`
        });
      }
    })
    .catch(err => {
      console.error("Error: ", err);
      res.status(500).send({
        message: `Error retrieving Staff with email=${email}`
      });
    });
  };
  

exports.update = async (req, res) => {
    console.log('Received request to update id:', req.params.id);
    console.log(req.body);
    const id = req.params.id;
    const { staff, person, canLogin, userLogin } = req.body; // Destructuring to separate staff, person, and login data

    try {
        // Update Staff related data
        const staffUpdateResult = await Staff.update(staff, {
            where: { staffid: id }
        });

        if (staffUpdateResult[0] === 1) {
            // Update Person related data
            const personUpdateResult = await Person.update(person, {
                where: { personid: staff.personid } // Assuming staff.personid holds the correct personid
            });

            if (personUpdateResult[0] === 1) {
                // Handle UserLogin data
                const existingLogin = await UserLogin.findOne({
                    where: { staff_id: id }
                });

                if (existingLogin) {
                    // UserLogin exists
                    if (!canLogin) {
                        // Delete existing UserLogin if canLogin is now false
                        await UserLogin.destroy({
                            where: { staff_id: id }
                        });
                    } else {
                        // Update existing UserLogin if canLogin remains true
                        const { email, password, role } = userLogin;
                        let passwordHash = existingLogin.password_hash;

                        // Hash the new password if provided
                        if (password) {
                            passwordHash = await bcrypt.hash(password, saltRounds);
                        }

                        await UserLogin.update({
                            email: email,
                            password_hash: passwordHash,
                            role: role
                        }, {
                            where: { staff_id: id }
                        });
                    }
                } else {
                    // Create a new UserLogin if canLogin is now true
                    if (canLogin) {
                        const { email, password, role } = userLogin;
                        const passwordHash = await bcrypt.hash(password, saltRounds);

                        await UserLogin.create({
                            email: email,
                            password_hash: passwordHash,
                            role: role,
                            staff_id: id
                        });
                    }
                }

                res.send({
                    message: "Staff was updated successfully."
                });
            } else {
                res.status(500).send({
                    message: `Cannot update Person with id=${staff.personid}.`
                });
            }
        } else {
            res.status(500).send({
                message: `Cannot update Staff with id=${id}.`
            });
        }
    } catch (err) {
        console.error("Error: ", err);
        res.status(500).send({
            message: "Error updating Staff with id=" + id
        });
    }
};



exports.fetchJobs = (req, res) => {
    Job.findAll({
      attributes: ['jobid', 'jobtitle'],
      where: {
        isplaceholder: false // Assuming you want to exclude placeholder jobs
      }
    })
    .then(jobs => {
      res.send(jobs);
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving job titles."
      });
    });
  };

  exports.findAllByJobId = (req, res) => {
    const jobId = req.params.jobId;

    Staff.findAll({
        where: { jobid: jobId },
        include: [{
            model: Person,
            as: 'person',
            attributes: ['personid', 'firstname', 'lastname', 'mobilephone', 'email', 'country', 'dateofbirth', 'weight', 'isplaceholder']
            // Add any other person attributes you need
        },
        {
            model: Job,
            as: 'job',
            attributes: ['jobid', 'jobtitle'] // Add any other job attributes you need
        }],
        attributes: ['staffid', 'personid', 'jobid', 'isplaceholder'] // Add any other staff attributes you need
    })
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        console.error("Error: ", err);
        res.status(500).send({
            message: err.message || "Some error occurred while retrieving staff members."
        });
    });
};

