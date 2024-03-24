const express = require("express");
const router = express.Router();
const axios = require("axios").default;
const qs = require("query-string");
const db = require("../app/models");

const config = {
  headers: {
    "Content-Type": "application/json", // Change content type to JSON
  },
};

const zapiToken = process.env.ZAPI_TOKEN;
const zapiAccountId = process.env.ZAPI_ACCOUNT_ID;
const zapiUserId = process.env.ZAPI_USER_ID;
const zauiUrl = process.env.ZAPI_URL;

//ZAPI PING
router.post("/zaui-ping", (req, res) => {
  // Request data from the client
  const requestData = req.body;

  // Modify the request to include your Zaui credentials
  requestData.zapiToken = zapiToken; 
  requestData.zapiAccountId = zapiAccountId; 
  requestData.zapiUserId = zapiUserId; 
  requestData.zapiMethod = {
    methodName: "zapiPing"
  };

  // Make a POST request to Zaui
  axios
    .post(
      zauiUrl,
      requestData,
      config
    )
    .then((result) => {
      // Forward the response from Zaui to the client
      res.json(result.data);
    })
    .catch((err) => {
      console.error(err);
      res.status(500).json({ error: "Failed to ping the Zaui server" });
    });
});

//ZAPI GET MANIFEST
router.get("/get-booking-by-day", (req, res) => {
  // Request data from the client
  const requestData = req.body;
  const date = req.query.date;

  // Modify the request to include your Zaui credentials, use .env variables
  requestData.zapiToken = zapiToken; 
  requestData.zapiAccountId = zapiAccountId; 
  requestData.zapiUserId = zapiUserId; 
  requestData.zapiMethod = {
    methodName: "zapiGetManifestEntireDayByDate",
    date: date,
  };
  // Make a POST request to Zaui
  axios
    .post(
      zauiUrl,
      requestData,
      config
    )
    .then((result) => {
      // Forward the response from Zaui to the client (vue frontned)
      res.json(result.data);
    })
    .catch((err) => {
      console.error(err);
      res.status(500).json({ error: "Failed to reach the Zaui server" });
    });
});

router.get('/zaui-status', async (req, res) => {

  try {
      const latestStatus = await db.zauiStatuses.findOne({
          order: [['createdat', 'DESC']]
      });

      if (latestStatus) {

          res.json(latestStatus);
      } else {
          res.status(404).send('No status found');
      }
  } catch (error) {
      console.error('Error fetching Zaui status:', error);
      res.status(500).send('Server error');
  }
});

router.get('/zaui-statuses-hourly', async (req, res) => {
  try {
    const hourlyStatuses = await db.zauiStatuses.findAll({
      // Assuming 'createdAt' is a timestamp column in your table
      where: {
        createdat: {
          [db.Sequelize.Op.gt]: new Date(Date.now() - 24 * 60 * 60 * 1000)
        }
      },
      order: [['createdat', 'DESC']]
    });
    res.json(hourlyStatuses);
  } catch (error) {
    console.error('Error fetching hourly Zaui statuses:', error);
    res.status(500).send('Server error');
  }
});


router.get('/zaui-statuses-daily', async (req, res) => {
  try {
    const dailyAverages = await db.zauiStatuses.findAll({
      attributes: [
        [db.Sequelize.fn('date', db.Sequelize.col('createdat')), 'date'],
        [db.Sequelize.fn('ROUND', db.Sequelize.fn('AVG', db.Sequelize.col('responsetime'))), 'averageResponseTime']
      ],
      group: 'date',
      order: [['date', 'DESC']]
    });
    res.json(dailyAverages);
  } catch (error) {
    console.error('Error fetching daily Zaui statuses:', error);
    res.status(500).send('Server error');
  }
});

// get the manifest for a specific date, this includes all activities for one day. automatically maps it to a client, person and reservation if they exist
// or creates new ones if they dont exist.
router.get("/get-date-manifest", (req, res) => {
  const date = req.query.date; // Get the date from the query string

  // Prepare the request payload with the required ZAPI details
  const requestData = {
    zapiToken: zapiToken,
    zapiAccountId: zapiAccountId,
    zapiUserId: zapiUserId,
    zapiMethod: {
      methodName: "zapiGetManifestEntireDayByDate",
      date: date, // The date received from the query
    },
  };

  // Make a POST request to Zaui to get the manifest
  axios
    .post(
      zauiUrl,
      requestData,
      config
    )
    .then((result) => {
      // Process the result to map the data into your DB schema (this will be a separate function)
      const mappedData = mapManifestToDBSchema(result.data);
      // Return the mapped data instead of the raw result
      res.json(mappedData);
    })
    .catch((err) => {
      console.error('Error getting the manifest from Zaui:', err);
      res.status(500).json({ error: "Failed to get the manifest from the Zaui server" });
    });
});

// OLD MAPPING CODE:
// // Map the Zaui manifest received into db 
// async function mapManifestToDBSchema(manifestData) {
  // const activitiesData = manifestData.response.methodResponse.activities.activity;

  // // Process each activity
  // try {
  //   const results = await Promise.all(activitiesData.map(async (activityData) => {
//       // Find or create the activity
//       const [activity, _] = await db.activities.findOrCreate({
//         where: {
//           zauiactivityid: activityData.activityId,
//           activityname: activityData.activityName
//         },
//         defaults: {
//           zauiactivityid: activityData.activityId,
//           activityname: activityData.activityName
//         }
//       });

//       // Process each booking within the activity
//       let bookings = Array.isArray(activityData.allBookings.booking) ? activityData.allBookings.booking : [activityData.allBookings.booking];

//       const bookingPromises = bookings.map(async (booking, index) => {
//         try {
//           return await db.sequelize.transaction(async (transaction) => {
//             console.log(`Processing Booking ${index + 1}:`, booking);

//             // Check for existing person or create a new one
//             const [person, personCreated] = await db.persons.findOrCreate({
//               where: {
//                 email: booking.email,
//                 firstname: booking.guestFirstName,
//                 lastname: booking.guestLastName
//               },
//               defaults: {
//                 firstname: booking.guestFirstName,
//                 lastname: booking.guestLastName,
//                 mobilephone: booking.mobile && typeof booking.mobile === 'string' ? booking.mobile.replace(/[^0-9]/g, '') : 9999999999
//                 // ... other person fields
//               },
//               transaction
//             });

//             console.log(`Person ${personCreated ? 'created' : 'found'}:`, person);

//             let client;
//             if (personCreated) {
//               client = await db.clients.create({ personid: person.personid }, { transaction });

//               // Fetch additional details from Zaui
//               const guestProfile = await getGuestProfile(booking);
//               if (guestProfile.methodErrorCode != '99' && guestProfile.response.methodResponse.guestDetails) {
//                 const guestDetails = guestProfile.response.methodResponse.guestDetails;

//                 let country;
//                 if (guestDetails.country && typeof guestDetails.country === 'string') {
//                   country = guestDetails.country;
//                 } else if (Array.isArray(guestDetails.country) && guestDetails.country.length > 0) {
//                   country = guestDetails.country[0];
//                 } else {
//                   country = 'no country';
//                 }

//                 const weightField = guestDetails.userCustomFields && guestDetails.userCustomFields.customField.find(field => field.customFieldLabel === 'Weight');
//                 const weight = weightField ? parseInt(weightField.customFieldValue.replace(/[^\d]/g, '')) : 999;

//                 await db.persons.update(
//                   {
//                     dateofbirth: guestDetails.birthDate,
//                     weight: weight,
//                     country: country
//                   },
//                   { where: { personid: person.personid }, transaction }
//                 );
//               }
//             } else {
//               client = await db.clients.findOne({ where: { personid: person.personid }, transaction });
//             }

//             console.log('Client:', client);

//             const [reservation, reservationCreated] = await db.reservation.findOrCreate({
//               where: { zauireservationid: booking.bookingNumber },
//               defaults: {
//                 personid: person.personid,
//                 activitydate: manifestData.response.methodResponse.manifestDate,
//                 balanceowing: booking.outstandingBalance,
//                 zauireservationid: booking.bookingNumber,
//                 activityid: activity.activityid
//               },
//               transaction
//             });

//             console.log(`Reservation ${reservationCreated ? 'created' : 'found'}:`, reservation);

//             // Create ReservationDetail linked to the reservation
//             await db.reservationDetails.create({
//               reservationid: reservation.reservationid,
//               activityid: activity.activityid,
//               // Add other relevant fields and defaults for reservationDetails here
//             }, { transaction });

//             return { person, client, reservation };
//           });
//         } catch (error) {
//           console.error("Error processing booking:", error);
//           return null;
//         }
//       });

//       return Promise.all(bookingPromises);
//     }));

//     return results.flat();
//   } catch (error) {
//     console.error("Error in processing all activities and bookings:", error);
//     return [];
//   }
// }

async function mapManifestToDBSchema(manifestData) {
  var activitiesData = manifestData.response.methodResponse.activities.activity;
  var manifestActivityDate = manifestData.response.methodResponse.manifestDate;
  activitiesData = Array.isArray(activitiesData) ? activitiesData : [activitiesData];

  // Process each activity
  try {
    const results = await Promise.all(activitiesData.map(async (activityData) => {
      const [activity, _] = await db.activities.findOrCreate({
        where: {
          zauiactivityid: activityData.activityId,
          activityname: activityData.activityName
        },
        defaults: {
          zauiactivityid: activityData.activityId,
          activityname: activityData.activityName
        }
      });

      let bookings = Array.isArray(activityData.allBookings.booking) ? activityData.allBookings.booking : [activityData.allBookings.booking];

      const bookingPromises = bookings.map(async (booking, index) => {
        return await db.sequelize.transaction(async (transaction) => {
          console.log(`Processing Booking ${index + 1}:`, booking);

          const [person, personCreated] = await db.persons.findOrCreate({
            where: {
              email: booking.email,
              firstname: booking.guestFirstName,
              lastname: booking.guestLastName
            },
            defaults: {
              firstname: booking.guestFirstName,
              lastname: booking.guestLastName,
              mobilephone: booking.mobile && typeof booking.mobile === 'string' ? booking.mobile.replace(/[^0-9]/g, '') : 9999999999
              // other person fields
            },
            transaction
          });

          console.log(`Person ${personCreated ? 'created' : 'found'}:`, person);

          let client = personCreated ? 
                       await db.clients.create({ personid: person.personid }, { transaction }) : 
                       await db.clients.findOne({ where: { personid: person.personid }, transaction });

          console.log('Client:', client);

          // Handle Custom Fields
          const guestProfile = await getGuestProfile(booking);

          //OLD GUEST PROFILE MAPPING
          // if (guestProfile && guestProfile.response.methodResponse.guestDetails && guestProfile.response.methodResponse.guestDetails.userCustomFields) {
          //   for (const field of guestProfile.response.methodResponse.guestDetails.userCustomFields.customField) {
          //     const fieldValue = typeof field.customFieldValue === 'object' ? JSON.stringify(field.customFieldValue) : field.customFieldValue;
          //     const [customField, created] = await db.personCustomFields.findOrCreate({
          //       where: {
          //         personid: person.personid,
          //         field_name: field.customFieldLabel
          //       },
          //       defaults: {
          //         field_value: fieldValue
          //       },
          //       transaction
          //     });

          //     if (!created) {
          //       await customField.update({
          //         field_value: fieldValue
          //       }, { transaction });
          //     }
          //   }
          // }

          if (guestProfile && guestProfile.response.methodResponse.guestDetails && guestProfile.response.methodResponse.guestDetails.userCustomFields) {
            for (const field of guestProfile.response.methodResponse.guestDetails.userCustomFields.customField) {
              const fieldValue = typeof field.customFieldValue === 'object' ? JSON.stringify(field.customFieldValue) : field.customFieldValue;
          
              let customFieldOption = await db.customFieldOptions.findOne({
                where: { field_name: field.customFieldLabel }
              });
              
              // If not found, try a "like" search
              if (!customFieldOption) {
                customFieldOption = await db.customFieldOptions.findOne({
                  where: {
                    field_name: {
                      [db.Sequelize.Op.like]: `%${field.customFieldLabel}%`
                    }
                  }
                });
              }
              
              // If still not found, create a new customFieldOption
              if (!customFieldOption) {
                console.log(`Custom field option not found for label: ${field.customFieldLabel}, creating new.`);
                customFieldOption = await db.customFieldOptions.create({
                  field_name: field.customFieldLabel
                });
              }
          
              const [customField, created] = await db.personCustomFields.findOrCreate({
                where: {
                  personid: person.personid,
                  custom_field_option_id: customFieldOption.id
                },
                defaults: {
                  field_name: field.customFieldLabel, // Include the field name here
                  field_value: fieldValue,
                  custom_field_option_id: customFieldOption.id
                },
                transaction
              });
              
              if (!created) {
                // If the custom field exists, update the field_value (and field_name if needed)
                await customField.update({
                  field_name: field.customFieldLabel, // Optionally update the field name as well
                  field_value: fieldValue,
                  custom_field_option_id: customFieldOption.id // This should remain the same but included for completeness
                }, { transaction });
              }
            }
          }
        
          const [reservation, reservationCreated] = await db.reservation.findOrCreate({
            where: { zauireservationid: booking.bookingNumber },
            defaults: {
              personid: person.personid,
              activitydate: manifestActivityDate || new Date().toISOString().slice(0, 10), //will default to today if theres no activity date
              balanceowing: booking.outstandingBalance,
              zauireservationid: booking.bookingNumber,
              activityid: activity.activityid
            },
            transaction
          });

          console.log(`Reservation ${reservationCreated ? 'created' : 'found'}:`, reservation);

          await db.reservationDetails.create({
            reservationid: reservation.reservationid,
            activityid: activity.activityid,
            // Add other relevant fields and defaults for reservationDetails here
          }, { transaction });

          return { person, client, reservation };
        }).catch(error => {
          console.error("Error processing booking:", error);
          return null;
        });
      });

      return Promise.all(bookingPromises);
    }));

    return results.flat();
  } catch (error) {
    console.error("Error in processing all activities and bookings:", error);
    return [];
  }
}


async function getGuestProfile(booking) {
  try {
    const requestData = {
      zapiToken: process.env.ZAPI_TOKEN,
      zapiAccountId: process.env.ZAPI_ACCOUNT_ID,
      zapiUserId: process.env.ZAPI_USER_ID,
      zapiMethod: {
        methodName: "zapiGuests_Lookup",
        firstName: booking.guestFirstName,
        lastName: booking.guestLastName,
        mobilePhone: booking.mobile,
        bookingID: booking.bookingNumber,
        email: booking.email
      },
    };

    const response = await axios.post(zauiUrl, requestData, config);
    console.log(response.data);
    return response.data;
  } catch (error) {
    console.error("Error fetching guest details from Zaui:", error);
    return null;
  }
}


router.post("/get-guest-profile-by-booking", async (req, res) => {
  try {
    const bookingData = req.body;
    const profile = await getGuestProfile(bookingData);
    res.json(profile);
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
});




module.exports = router;