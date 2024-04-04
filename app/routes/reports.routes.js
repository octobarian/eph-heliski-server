module.exports = app => {
    const reports = require("../controllers/reports.controller.js");

    var router = require("express").Router();

    // Create a new Note
    router.get('/dailyTripsReport', reports.dailyTripsReport);

    // Route for fetching medical report data
    router.get('/medicalReport', reports.medicalReport);

    // Route for fetching medical report data
    router.get('/lunchReport', reports.lunchReport);

    app.use('/api/reports', router);
};