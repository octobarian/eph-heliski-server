const dbConfig = require("../config/db.config.js");
const Sequelize = require("sequelize");

const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,
  operatorsAliases: false,

  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle
  }
});

const db = {};

//Requires both imports to handle 
db.Sequelize = Sequelize;
db.sequelize = sequelize;

// Models/tables (ADD MODEL FOR EACH MODEL HERE)
//People Models
db.tutorials = require("./tutorial.model.js")(sequelize, Sequelize);
db.clients = require("./client.model.js")(sequelize, Sequelize); 
db.persons = require("./person.model.js")(sequelize, Sequelize); 
db.personCustomFields = require("./personCustomFields.model.js")(sequelize, Sequelize);
db.customFieldOptions = require("./customFieldOptions.model.js")(sequelize, Sequelize);


// Import models for the Health tables
db.personhealth = require("./personHealth.model.js")(sequelize, Sequelize);
db.healthrecordtypes = require("./healthRecordTypes.model.js")(sequelize, Sequelize);
db.healthrecordvalues = require("./healthRecordValues.model.js")(sequelize, Sequelize);
db.healthseverities = require("./healthSeverities.model.js")(sequelize, Sequelize);

//staff imports
db.staffs = require("./staff.model.js")(sequelize, Sequelize);
db.jobs = require("./job.model.js")(sequelize, Sequelize); // Uncomment and modify as needed

//reservation imports
db.reservation = require('./reservation.model.js')(sequelize, Sequelize);
db.reservationDetails = require('./reservationdetails.model.js')(sequelize, Sequelize);
db.activities = require('./activities.model.js')(sequelize, Sequelize);

//zaui imports
db.zauiStatuses = require("./zauiStatus.model.js")(sequelize, Sequelize);
db.zauiDailyManifest = require("./zauiDailyManifest.model.js")(sequelize, Sequelize);

//Trip Imports
db.helicopters = require('./helicopter.model.js')(sequelize, Sequelize);
db.trips = require('./trip.model.js')(sequelize, Sequelize);
db.tripStaff = require('./tripStaff.model.js')(sequelize, Sequelize);
db.tripClients = require('./tripclient.model.js')(sequelize, Sequelize);
db.tripGroups = require('./tripGroup.model.js')(sequelize, Sequelize);

//Equipment Imports (heli, beacon, van, etc)
db.beacons = require('./beacon.model.js')(sequelize, Sequelize);

//Notes imports
db.notes = require('./notes.model.js')(sequelize, Sequelize);



// Define associations
// Associate personhealth with person
db.persons.hasMany(db.personhealth, { foreignKey: 'personid', as: 'personhealth' });
// Associate personhealth with healthrecordvalues
db.personhealth.belongsTo(db.healthrecordvalues, { foreignKey: 'healthrecordvalueid', as: 'healthrecordvalue' });
// Associate personhealth with healthseverities
db.personhealth.belongsTo(db.healthseverities, { foreignKey: 'severityid', as: 'severity' });
// Associate healthRecord Value with Recordtypes
db.healthrecordvalues.belongsTo(db.healthrecordtypes, { foreignKey: 'healthrecordtypeid', as: 'healthrecordtype' });
// Associating Customvalues to person
// Association between Persons and PersonCustomFields
db.persons.hasMany(db.personCustomFields, { foreignKey: 'personid', as: 'customFields' });
db.personCustomFields.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });

// Association between PersonCustomFields and CustomFieldOptions
db.personCustomFields.belongsTo(db.customFieldOptions, { foreignKey: 'custom_field_option_id', as: 'customFieldDefinition' });
db.customFieldOptions.hasMany(db.personCustomFields, { foreignKey: 'custom_field_option_id', as: 'customFieldInstances' });


// client Relation 
db.clients.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
// Staff Relations
db.staffs.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
db.staffs.belongsTo(db.jobs, { foreignKey: 'jobid', as: 'job' }); 
db.staffs.hasMany(db.tripStaff, { foreignKey: 'staffid', as: 'staffMembers' });

// Reservation Relations
db.reservation.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
db.reservation.hasMany(db.reservationDetails, { foreignKey: 'reservationid', as: 'details' });
db.reservation.hasMany(db.tripClients, {foreignKey: 'reservationid',as: 'tripClients'});

// ReservationDetails Relation
db.reservationDetails.belongsTo(db.reservation, { foreignKey: 'reservationid', as: 'reservation' });

// ReservationDetails and Activities Association
db.reservationDetails.belongsTo(db.activities, { foreignKey: 'activityid', as: 'activity' });
db.activities.hasMany(db.reservationDetails, { foreignKey: 'activityid', as: 'reservationDetails' });


// Trip Relations
db.trips.belongsTo(db.staffs, { foreignKey: 'pilotid', as: 'pilot' }); // Assuming staffs table contains pilots
db.trips.belongsTo(db.helicopters, { foreignKey: 'helicopterid', as: 'helicopter' });
db.trips.hasMany(db.tripStaff, { foreignKey: 'tripid', as: 'tripStaff' });
db.trips.belongsTo(db.notes, { foreignKey: 'noteid', as: 'note' });

// Helicopter Relations
db.helicopters.hasMany(db.trips, { foreignKey: 'helicopterid', as: 'trips' });

// TripStaff Associations
db.tripStaff.belongsTo(db.trips, { foreignKey: 'tripid', as: 'trip' });
db.tripStaff.belongsTo(db.staffs, { foreignKey: 'staffid', as: 'staff' });

// TripClient Associations
db.tripClients.belongsTo(db.clients, { foreignKey: 'clientid', as: 'client' });
db.clients.hasMany(db.tripClients, { foreignKey: 'clientid', as: 'tripClients' });
db.tripClients.belongsTo(db.reservation, {foreignKey: 'reservationid',as: 'reservation'});

// TripGroup Associations
db.trips.hasMany(db.tripGroups, { foreignKey: 'trip_id', as: 'tripGroups' });
db.staffs.hasMany(db.tripGroups, { foreignKey: 'guide_id', as: 'guidedGroups' });
db.tripGroups.belongsTo(db.staffs, { foreignKey: 'guide_id', as: 'guide' });

// Modify the TripClient associations
db.tripClients.belongsTo(db.tripGroups, { foreignKey: 'trip_group_id', as: 'tripGroup' });
db.tripGroups.hasMany(db.tripClients, { foreignKey: 'trip_group_id', as: 'tripClients' });

// Beacon Associations
db.beacons.belongsTo(db.tripClients, { foreignKey: 'tripclientid', as: 'tripClient', allowNull: true });
db.tripClients.hasOne(db.beacons, { foreignKey: 'tripclientid', as: 'beacon' });

// Notes Associations
db.persons.hasMany(db.notes, { foreignKey: 'personid', as: 'notes' });
db.notes.hasOne(db.trips, { foreignKey: 'noteid' });


//One to many associations
db.trips.belongsToMany(db.clients, {
  through: db.tripClients,
  foreignKey: 'tripid',
  otherKey: 'clientid',
  as: 'clients'
});

db.clients.belongsToMany(db.trips, {
  through: db.tripClients,
  foreignKey: 'clientid',
  otherKey: 'tripid',
  as: 'trips'
});

db.trips.belongsToMany(db.reservation, {
  through: db.tripClients,
  foreignKey: 'tripid',
  otherKey: 'reservationid',
  as: 'reservations'
});

db.reservation.belongsToMany(db.trips, {
  through: db.tripClients,
  foreignKey: 'reservationid',
  otherKey: 'tripid',
  as: 'trips'
});

module.exports = db;
