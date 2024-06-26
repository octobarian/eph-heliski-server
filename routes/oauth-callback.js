const express = require("express");
const router = express.Router();
const axios = require("axios").default;
const qs = require("query-string");

const config = {
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
  },
};
const url = `${process.env.FUSIONAUTH_SERVER_IP}:${process.env.FUSIONAUTH_PORT}/oauth2/token`;

router.get("/", (req, res) => {
// State from Server
const stateFromServer = req.query.state;
if (stateFromServer !== req.session.stateValue) {
  console.log("State doesn't match. uh-oh.");
  console.log(`Saw: ${stateFromServer}, but expected: &{req.session.stateValue}`);
  res.redirect(302, '/');
  return;
}
  //post request to /token endpoint
  axios
    .post(
      url,
      qs.stringify({
        client_id: process.env.FUSIONAUTH_CLIENT_ID,
        client_secret: process.env.FUSIONAUTH_CLIENT_SECRET,
        code: req.query.code,
        grant_type: "authorization_code",
        redirect_uri: process.env.FUSIONAUTH_REDIRECT_URI,
      }),
      config
    )
    .then((result) => {

      // save token to session
      req.session.token = result.data.access_token;
      console.log(result)
      //redirect to Vue app
      res.redirect(process.env.VUE_APP_IP+":"+process.env.VUE_APP_PORT);
    })
    .catch((err) => {
      console.error(err);
    });
});
module.exports = router;