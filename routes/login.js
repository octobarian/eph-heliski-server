const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {

  const stateValue = Math.random().toString(36).substring(2,15) + Math.random().toString(36).substring(2,15) + Math.random().toString(36).substring(2,15) + Math.random().toString(36).substring(2,15) + Math.random().toString(36).substring(2,15) + Math.random().toString(36).substring(2,15);

  req.session.stateValue = stateValue

  res.redirect(`http://${process.env.FUSIONAUTH_SERVER_IP}:${process.env.FUSIONAUTH_PORT}/oauth2/authorize?client_id=${process.env.FUSIONAUTH_CLIENT_ID}&redirect_uri=${process.env.FUSIONAUTH_REDIRECT_URI}&response_type=code&state=${stateValue}`);
});
module.exports = router;