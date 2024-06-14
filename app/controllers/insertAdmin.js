// ./app/config/insertAdmin.js

const db = require("../models");
const bcrypt = require('bcrypt');
require('dotenv').config();

const Staff = db.staffs;
const Person = db.persons;
const UserLogin = db.user_logins;

const createAdminUser = async () => {
  const email = process.env.ADMIN_EMAIL;
  const password = process.env.ADMIN_PASSWORD;
  const role = 'admin';

  try {
    // Check if admin user already exists
    const [existingUser, created] = await UserLogin.findOrCreate({
      where: { email },
      defaults: {
        email,
        password_hash: await bcrypt.hash(password, 12),
        role,
      }
    });

    if (created) {
      // Admin user did not exist and was created

      // Create Person record or find existing
      const [personData] = await Person.findOrCreate({
        where: { email },
        defaults: {
          firstname: 'Admin',
          lastname: 'User',
          email,
          // Add other person details if necessary
        }
      });

      // Create Staff record or find existing
      const [staffData] = await Staff.findOrCreate({
        where: { personid: personData.personid },
        defaults: {
          personid: personData.personid,
          jobid: 3, // Assuming jobid is optional or can be null
          isplaceholder: true,
        }
      });

      // Update UserLogin with staff_id if newly created
      if (!existingUser.staff_id) {
        await UserLogin.update(
          { staff_id: staffData.staffid },
          { where: { email } }
        );
      }

      console.log('Admin user created successfully.');
    } else {
      console.log('Admin user already exists.');
    }
  } catch (error) {
    console.error('Error creating admin user:', error);
  }
};

module.exports = createAdminUser;
