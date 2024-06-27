module.exports = app => {
  const clients = require("../controllers/client.controller.js");

  var router = require("express").Router();

  // Create a new Client
  router.post("/", clients.create);

  // Retrieve all Clients
  router.get("/", clients.findAll);

  router.get("/severities", clients.fetchSeverities);

  // Retrieve a single Client with id
  router.get("/id/:id", clients.findOne);

  // Update a Client with id
  router.put("/id/:id", clients.update);

  // Update a Client's weight by personid
  router.put("/weight/:personid", clients.updateWeight);

  // Delete a Client with id
  router.delete("/id/:id", clients.delete);

  // Delete all Clients
  router.delete("/", clients.deleteAll);

  // Find by Name
  router.get("/name", clients.findByName);

  // Find Clientid vie Personid
  router.get('/byperson/:personId', clients.findByPersonId);

  app.use('/api/clients', router);
};
