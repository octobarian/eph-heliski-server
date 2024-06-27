require('dotenv').config();

module.exports = {
  development: {
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    host: process.env.DB_HOST,
    dialect: 'postgres',
    pool: {
      max: parseInt(process.env.DB_POOL_MAX, 10),
      min: parseInt(process.env.DB_POOL_MIN, 10),
      acquire: parseInt(process.env.DB_POOL_ACQUIRE, 10),
      idle: parseInt(process.env.DB_POOL_IDLE, 10)
    }
  },
  production: {
    username: process.env.AZURE_DB_USER,
    password: process.env.AZURE_DB_PASSWORD,
    database: process.env.AZURE_DB_NAME,
    host: process.env.AZURE_DB_HOST,
    dialect: 'postgres',
    pool: {
      max: parseInt(process.env.AZURE_DB_POOL_MAX, 10),
      min: parseInt(process.env.AZURE_DB_POOL_MIN, 10),
      acquire: parseInt(process.env.AZURE_DB_POOL_ACQUIRE, 10),
      idle: parseInt(process.env.AZURE_DB_POOL_IDLE, 10)
    }
  }
};
