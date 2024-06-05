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
    },
    dialectOptions: dbConfig.dialectOptions,
});

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;

// Models/tables (ADD MODEL FOR EACH MODEL HERE)
db.tutorials = require("./tutorial.model.js")(sequelize, Sequelize);
db.clients = require("./client.model.js")(sequelize, Sequelize);
db.persons = require("./person.model.js")(sequelize, Sequelize);
db.personCustomFields = require("./personCustomFields.model.js")(sequelize, Sequelize);
db.customFieldOptions = require("./customFieldOptions.model.js")(sequelize, Sequelize);
db.personhealth = require("./personHealth.model.js")(sequelize, Sequelize);
db.healthrecordtypes = require("./healthRecordTypes.model.js")(sequelize, Sequelize);
db.healthrecordvalues = require("./healthRecordValues.model.js")(sequelize, Sequelize);
db.healthseverities = require("./healthSeverities.model.js")(sequelize, Sequelize);
db.staffs = require("./staff.model.js")(sequelize, Sequelize);
db.jobs = require("./job.model.js")(sequelize, Sequelize);
db.reservation = require('./reservation.model.js')(sequelize, Sequelize);
db.reservationDetails = require('./reservationdetails.model.js')(sequelize, Sequelize);
db.activities = require('./activities.model.js')(sequelize, Sequelize);
db.zauiStatuses = require("./zauiStatus.model.js")(sequelize, Sequelize);
db.zauiDailyManifest = require("./zauiDailyManifest.model.js")(sequelize, Sequelize);
db.trips = require('./trip.model.js')(sequelize, Sequelize);
db.tripStaff = require('./tripStaff.model.js')(sequelize, Sequelize);
db.tripClients = require('./tripclient.model.js')(sequelize, Sequelize);
db.tripGroups = require('./tripGroup.model.js')(sequelize, Sequelize);
db.tripShuttles = require("./tripShuttles.model.js")(sequelize, Sequelize);
db.beacons = require('./beacon.model.js')(sequelize, Sequelize); 
db.helicopters = require('./helicopter.model.js')(sequelize, Sequelize); 
db.shuttles = require('./shuttle.model.js')(sequelize, Sequelize);
db.notes = require('./notes.model.js')(sequelize, Sequelize);
db.runs = require('./runs.model.js')(sequelize, Sequelize); 
db.zones = require('./zones.model.js')(sequelize, Sequelize);
db.tripruns = require('./tripruns.model.js')(sequelize, Sequelize); 
db.wildlife = require('./wildlife.model.js')(sequelize, Sequelize);
db.persontraining = require('./personTraining.model.js')(sequelize, Sequelize); 
db.trainingtype = require('./trainingType.model.js')(sequelize, Sequelize);

// Define associations
db.persons.hasMany(db.personhealth, { foreignKey: 'personid', as: 'personhealth' });
db.personhealth.belongsTo(db.healthrecordvalues, { foreignKey: 'healthrecordvalueid', as: 'healthrecordvalue' });
db.personhealth.belongsTo(db.healthseverities, { foreignKey: 'severityid', as: 'severity' });
db.healthrecordvalues.belongsTo(db.healthrecordtypes, { foreignKey: 'healthrecordtypeid', as: 'healthrecordtype' });

db.persons.hasMany(db.personCustomFields, { foreignKey: 'personid', as: 'customFields' });
db.personCustomFields.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
db.personCustomFields.belongsTo(db.customFieldOptions, { foreignKey: 'custom_field_option_id', as: 'customFieldDefinition' });
db.customFieldOptions.hasMany(db.personCustomFields, { foreignKey: 'custom_field_option_id', as: 'customFieldInstances' });

db.clients.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });

db.staffs.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
db.staffs.belongsTo(db.jobs, { foreignKey: 'jobid', as: 'job' });
db.staffs.hasMany(db.tripStaff, { foreignKey: 'staffid', as: 'staffMembers' });

db.reservation.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
db.reservation.hasMany(db.reservationDetails, { foreignKey: 'reservationid', as: 'details' });
db.reservation.hasMany(db.tripClients, { foreignKey: 'reservationid', as: 'tripClients' });

db.reservationDetails.belongsTo(db.reservation, { foreignKey: 'reservationid', as: 'reservation' });
db.reservationDetails.belongsTo(db.activities, { foreignKey: 'activityid', as: 'activity' });
db.activities.hasMany(db.reservationDetails, { foreignKey: 'activityid', as: 'reservationDetails' });

db.trips.belongsTo(db.staffs, { foreignKey: 'pilotid', as: 'pilot' });
db.trips.belongsTo(db.helicopters, { foreignKey: 'helicopterid', as: 'helicopter' });
db.trips.hasMany(db.tripStaff, { foreignKey: 'tripid', as: 'tripStaff' });
db.trips.belongsTo(db.notes, { foreignKey: 'noteid', as: 'note' });
db.helicopters.hasMany(db.trips, { foreignKey: 'helicopterid', as: 'trips' });

db.shuttles.belongsTo(db.staffs, { foreignKey: 'staffid', as: 'staff' });
db.trips.hasMany(db.tripShuttles, { foreignKey: 'trip_id', as: 'tripShuttles' });
db.tripShuttles.belongsTo(db.trips, { foreignKey: 'trip_id', as: 'trip' });
db.shuttles.hasMany(db.tripShuttles, { foreignKey: 'shuttle_id', as: 'tripShuttles' });
db.tripShuttles.belongsTo(db.shuttles, { foreignKey: 'shuttle_id', as: 'shuttle' });
db.tripClients.hasMany(db.tripShuttles, { foreignKey: 'tripclientid', as: 'tripShuttles' });
db.tripShuttles.belongsTo(db.tripClients, { foreignKey: 'tripclientid', as: 'tripClient' });

db.tripStaff.belongsTo(db.trips, { foreignKey: 'tripid', as: 'trip' });
db.tripStaff.belongsTo(db.staffs, { foreignKey: 'staffid', as: 'staff' });

db.tripClients.belongsTo(db.clients, { foreignKey: 'clientid', as: 'client' });
db.clients.hasMany(db.tripClients, { foreignKey: 'clientid', as: 'tripClients' });
db.tripClients.belongsTo(db.reservation, { foreignKey: 'reservationid', as: 'reservation' });

db.trips.hasMany(db.tripGroups, { foreignKey: 'trip_id', as: 'tripGroups' });
db.staffs.hasMany(db.tripGroups, { foreignKey: 'guide_id', as: 'guidedGroups' });
db.tripGroups.belongsTo(db.staffs, { foreignKey: 'guide_id', as: 'guide' });
db.tripClients.belongsTo(db.tripGroups, { foreignKey: 'trip_group_id', as: 'tripGroup' });
db.tripGroups.hasMany(db.tripClients, { foreignKey: 'trip_group_id', as: 'tripClients' });
db.tripGroups.belongsTo(db.notes, { foreignKey: 'noteid', as: 'note' });

db.beacons.belongsTo(db.tripClients, { foreignKey: 'tripclientid', as: 'tripClient', allowNull: true });
db.tripClients.hasOne(db.beacons, { foreignKey: 'tripclientid', as: 'beacon' });

db.persons.hasMany(db.notes, { foreignKey: 'personid', as: 'notes' });
db.notes.hasOne(db.trips, { foreignKey: 'noteid' });

db.zones.hasMany(db.runs, { foreignKey: 'zoneid', as: 'runs' });
db.runs.belongsTo(db.zones, { foreignKey: 'zoneid', as: 'zone' });

db.trips.hasMany(db.tripruns, { foreignKey: 'tripid', as: 'tripRuns' });
db.runs.hasMany(db.tripruns, { foreignKey: 'runid', as: 'runTrips' });
db.tripruns.belongsTo(db.trips, { foreignKey: 'tripid', as: 'trip' });
db.tripruns.belongsTo(db.runs, { foreignKey: 'runid', as: 'run' });
db.tripruns.belongsTo(db.tripGroups, { foreignKey: 'trip_group_id', as: 'tripGroup' });

db.wildlife.belongsTo(db.runs, { foreignKey: 'runid', as: 'run' });
db.wildlife.belongsTo(db.tripGroups, { foreignKey: 'tripgroupid', as: 'tripGroup' });
db.wildlife.belongsTo(db.persons, { foreignKey: 'observerid', as: 'observer' });
db.tripGroups.hasMany(db.wildlife, { foreignKey: 'tripgroupid', as: 'wildlifeSightings' });
db.runs.hasMany(db.wildlife, { foreignKey: 'runid', as: 'wildlifeSightings' });
db.persons.hasMany(db.wildlife, { foreignKey: 'observerid', as: 'wildlifeSightings' });

db.persons.hasMany(db.persontraining, { foreignKey: 'personid', as: 'trainings' });
db.persontraining.belongsTo(db.persons, { foreignKey: 'personid', as: 'person' });
db.persontraining.belongsTo(db.trainingtype, { foreignKey: 'trainingtypeid', as: 'trainingType' });

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
