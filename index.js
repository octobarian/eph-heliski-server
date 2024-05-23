const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const session = require("express-session")

const db = require("./app/models");

const bodyParser = require("body-parser");

const checkSecret = require("./app/middleware/checkSecret.js");

const runMigrations = require('./app/controllers/dbMigrations.js');

// Load the .env variables into the build
require("dotenv").config();

const app = express();

// Use our middlewares
app.use(cors({ origin: true, credentials: true }));
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

//Sync up to the postgresql db
db.sequelize.sync()
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

//Middleware
app.use(checkSecret);

// routes
app.use('/user', checkSecret, require('./routes/user'))
app.use('/zaui', checkSecret, require('./routes/zaui'))
app.use('/login', require('./routes/login'))
app.use('/logout', require('./routes/logout'))
app.use('/oauth-callback', require('./routes/oauth-callback'))
app.use('/set-user-data', require('./routes/set-user-data'))

//db model routes
require("./app/routes/tutorial.routes")(app, checkSecret);
require("./app/routes/client.routes")(app, checkSecret);
require("./app/routes/staff.routes")(app, checkSecret);
require("./app/routes/trip.routes")(app, checkSecret);
require("./app/routes/notes.routes")(app, checkSecret);
require("./app/routes/equipment.routes")(app, checkSecret);
require("./app/routes/reservation.routes")(app, checkSecret);
require("./app/routes/reports.routes")(app, checkSecret);

//cron jobs imported
require("./app/cron/zauistatuscron");

app.get("/", (req, res) => {
  res.send({
   message:"FusionAuth Example With Vue"
  });
});

// Provide a default port 
const port =  process.env.SERVER_PORT || 3000;

// Listen to server  
(async () => {
  await runMigrations(); // Run the migration script
  app.listen(port, () => {
    console.log(`Listening on port ${port}`);
  });
})();