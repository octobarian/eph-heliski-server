const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const session = require("express-session")

const db = require("./app/models");

const bodyParser = require("body-parser");

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

// routes
app.use('/user', require('./routes/user'))
app.use('/zaui', require('./routes/zaui'))
app.use('/login', require('./routes/login'))
app.use('/logout', require('./routes/logout'))
app.use('/oauth-callback', require('./routes/oauth-callback'))
app.use('/set-user-data', require('./routes/set-user-data'))

//db model routes
require("./app/routes/tutorial.routes")(app);
require("./app/routes/client.routes")(app);
require("./app/routes/staff.routes")(app);
require("./app/routes/trip.routes")(app);
require("./app/routes/notes.routes")(app);
require("./app/routes/equipment.routes")(app);
require("./app/routes/reservation.routes")(app);
require("./app/routes/reports.routes")(app);

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
app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});