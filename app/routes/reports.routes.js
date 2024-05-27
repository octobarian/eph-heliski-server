module.exports = app => {
    const reports = require("../controllers/reports.controller.js");

    var router = require("express").Router();

    // Create a new Note
    router.get('/dailyTripsReport', reports.dailyTripsReport);

    // Route for fetching medical report data
    router.get('/medicalReport', reports.medicalReport);

    // Route for fetching lunch report data
    router.get('/lunchReport', reports.lunchReport);

    // Route for fetching daily shuttle report data
    router.get('/dailyShuttleReport', reports.dailyShuttleReport);

    app.use('/api/reports', router);
};
