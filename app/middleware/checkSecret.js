const CryptoJS = require("crypto-js");

function checkSecret(req, res, next) {
//   const encryptedClientSecret = req.headers['cust-server-secret'];
//   if (!encryptedClientSecret) {
//     return res.status(403).send({ message: 'Server secret is missing i see: '+JSON.stringify(req.headers) });
//   }

//   // Decrypt the client secret
//   const bytes = CryptoJS.AES.decrypt(encryptedClientSecret, process.env.SERVER_ENCRYPTION_KEY);
//   const clientSecret = bytes.toString(CryptoJS.enc.Utf8);

//   if (clientSecret !== process.env.SERVER_SECRET_KEY) {
//     return res.status(403).send({ message: 'Invalid server secret' });
//   }
  next();
}
module.exports = checkSecret;
