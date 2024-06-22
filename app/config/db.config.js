require('dotenv').config();

module.exports = {
  HOST: process.env.DB_HOST,
  USER: process.env.DB_USER,
  PASSWORD: process.env.DB_PASSWORD,
  DB: process.env.DB_NAME,
  dialect: process.env.DB_DIALECT,
  pool: {
    max: 10,
    min: 0,
    acquire: 60000,
    idle: 10000
  },
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false // For Azure, you might set this to false to bypass strict CA checks. For production, consider using CA cert.
    }
  }
};

// Force the connection to use the azure DB
// module.exports = {
//   HOST: process.env.AZURE_DB_HOST,
//   USER: process.env.AZURE_DB_USER,
//   PASSWORD: process.env.AZURE_DB_PASSWORD,
//   DB: process.env.AZURE_DB_NAME,
//   dialect: process.env.AZURE_DB_DIALECT,
//   pool: {
//     max: 10,
//     min: 0,
//     acquire: 30000,
//     idle: 10000
//   },
//   dialectOptions: {
//     ssl: {
//       require: true,
//       rejectUnauthorized: false // For Azure, you might set this to false to bypass strict CA checks. For production, consider using CA cert.
//     }
//   }
// };
