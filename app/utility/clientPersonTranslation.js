// In clientPersonTranslation.js inside the utils or helpers directory

const db = require('../models'); // Update the path according to your project structure

async function translatePersonIdToClientId(personId) {
  try {
    const client = await db.clients.findOne({ where: { personid: personId } });
    return client ? client.clientid : null;
  } catch (error) {
    console.error("Error translating personId to clientId:", error);
    return null;
  }
}

module.exports = {
  translatePersonIdToClientId
};
