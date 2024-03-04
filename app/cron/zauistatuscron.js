const cron = require('node-cron');
const axios = require('axios');
const db = require("../models");

const config = {
    headers: {
      "Content-Type": "application/json", // Change content type to JSON
    },
  };
  
const zapiToken = process.env.ZAPI_TOKEN;
const zapiAccountId = process.env.ZAPI_ACCOUNT_ID;
const zapiUserId = process.env.ZAPI_USER_ID;
const zauiUrl = process.env.ZAPI_URL;
  
//The Function which pings Zaui and returns the time it took to respond
async function pingZauiApi() {
    const requestData = {
        zapiToken: zapiToken,
        zapiAccountId: zapiAccountId,
        zapiUserId: zapiUserId,
        zapiMethod: {
            methodName: "zapiPing"
        }
    };

    try {
        const startTime = Date.now();
        const response = await axios.post(zauiUrl, requestData, config);
        const endTime = Date.now();

        var responsetime = endTime - startTime;
        var responsemessage = JSON.stringify(response.data.response.methodResponse.methodErrorMessage,);
        if (typeof responsemessage === 'string') {
            responsemessage = responsemessage.replace(/^"|"$/g, '');
        }

        return { responsetime,  responsemessage };
    } catch (error) {
        console.error('Error in pingZauiApi:', error);
        throw error;
    }
}

// Cron Job Function to ping Zaui API
async function pingZaui() {
    try {
        var { responsetime, responsemessage } = await pingZauiApi();

        // Save to database
        await db.zauiStatuses.create({
            responsetime,
            responsemessage
        });

        // Delete records older than a week
        const oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
        await db.zauiStatuses.destroy({
            where: {
                createdat: {
                    [db.Sequelize.Op.lt]: oneWeekAgo
                }
            }
        });
    } catch (error) {
        console.error('Error in pingZaui:', error);
    }
}

cron.schedule('0 */1 * * *', async () => {
    await pingZaui();
});