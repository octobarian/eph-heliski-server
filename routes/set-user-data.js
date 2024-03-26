const express = require("express");
const router = express.Router();
const axios = require("axios");
const qs = require("query-string");
router.post("/", (req, res) => {
  // POST request to /introspect endpoint
  axios
    .post(
      `http://${process.env.FUSIONAUTH_SERVER_IP}:${process.env.FUSIONAUTH_PORT}/oauth2/introspect`,
      qs.stringify({
        client_id: process.env.FUSIONAUTH_CLIENT_ID,
        token: req.session.token,
      })
    )
    .then((response) => {
      let introspectResponse = response.data;
    
      // PATCH request to /registration endpoint
      axios.patch(
        `http://${process.env.FUSIONAUTH_SERVER_IP}:${process.env.FUSIONAUTH_PORT}/api/user/registration/${introspectResponse.sub}/${process.env.FUSIONAUTH_APPLICATION_ID}`,
        {
          registration: {
            data: req.body,
          },
        },
        {
          headers: {
            Authorization: process.env.FUSIONAUTH_API_KEY,
          },
        }
      ).catch(err=>{
          console.log(err)
      })
    })
    .catch((err) => {
      console.error(err);
    });

});
module.exports = router;