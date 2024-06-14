const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const session = require("express-session")

const db = require("./app/models");

const bodyParser = require("body-parser");

const checkSecret = require("./app/middleware/checkSecret.js");

const runMigrations = require('./app/controllers/dbMigrations.js');
const createAdminUser = require('./app/controllers/insertAdmin.js');

// Load the .env variables into the build
require("dotenv").config();

const app = express();
const developmentAddress = process.env.DEVELOPMENT_CLIENT_ADDRESS;
const productionAddress = process.env.AZURE_CLIENT_ADDRESS;
const environmentRuntime = process.env.NODE_ENV;

const corsOptions = {
  origin: process.env.NODE_ENV === 'production' ? productionAddress : developmentAddress,
  credentials: true,
};

app.use(cors(corsOptions));
app.use(morgan("common"));
// parse requests of content-type - application/json
app.use(bodyParser.json());
// parse requests of content-type - application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
app.use(session(
  {
    secret: process.env.SERVER_SECRET, // TODO:don't use this secret in prod :)
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: 'auto',
      httpOnly: true,
      maxAge: 3600000
    }
  })
);

// Middleware
app.use(checkSecret);

// Routes
app.use('/user', checkSecret, require('./routes/user'));
app.use('/zaui', checkSecret, require('./routes/zaui'));
app.use('/login', require('./routes/login'));
app.use('/logout', require('./routes/logout'));
app.use('/oauth-callback', require('./routes/oauth-callback'));
app.use('/set-user-data', require('./routes/set-user-data'));

// DB model routes
require("./app/routes/tutorial.routes")(app, checkSecret);
require("./app/routes/client.routes")(app, checkSecret);
require("./app/routes/staff.routes")(app, checkSecret);
require("./app/routes/trip.routes")(app, checkSecret);
require("./app/routes/notes.routes")(app, checkSecret);
require("./app/routes/equipment.routes")(app, checkSecret);
require("./app/routes/reservation.routes")(app, checkSecret);
require("./app/routes/reports.routes")(app, checkSecret);
require("./app/routes/runs_zones.routes")(app, checkSecret);
require("./app/routes/wildlife.routes")(app, checkSecret);

// Cron jobs imported
require("./app/cron/zauistatuscron");

app.get("/", (req, res) => {
  res.send({
    message: "FusionAuth Example With Vue"
  });
});

// Provide a default port
const port = process.env.SERVER_PORT || 3000;

async function startServer() {
  try {
    await runMigrations();
    console.log('Migrations have been run successfully.');

    await createAdminUser(); // Call the function to create the admin user

    app.listen(port, () => {
      console.log(`Server is running on port ${port} in ${environmentRuntime}`);
    });
  } catch (error) {
    console.error('Error starting server:', error);
    process.exit(1); // Exit the process with an error code
  }
}

db.sequelize.sync()
  .then(() => {
    console.log("Synced db.");
    startServer(); // Call startServer after DB sync
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });
