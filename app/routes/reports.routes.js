module.exports = app => {
    const reports = require("../controllers/reports.controller.js");

    var router = require("express").Router();

    router.get('/dailyTripsReport', reports.dailyTripsReport);
    router.get('/medicalReport', reports.medicalReport);
    router.get('/lunchReport', reports.lunchReport);
    router.get('/dailyShuttleReport', reports.dailyShuttleReport);
    
    // New route for group list report
    router.get('/groupListReport', reports.groupListReport);
    router.get('/dailyRentalReport', reports.dailyRentalReport);

    app.use('/api/reports', router);
};
