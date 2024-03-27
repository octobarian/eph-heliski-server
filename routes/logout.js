const express = require('express');
const router = express.Router();
router.get('/', (req, res) => {
  // delete the session
  req.session.destroy();
  // end FusionAuth session
  res.redirect(`${process.env.FUSIONAUTH_SERVER_IP}:${process.env.FUSIONAUTH_PORT}/oauth2/logout?client_id=${process.env.FUSIONAUTH_CLIENT_ID}`);
});
module.exports = router;