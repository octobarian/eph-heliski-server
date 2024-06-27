const { sequelize } = require('../models'); // Adjust the path to your Sequelize instance
const { exec } = require('child_process');

async function runMigrations() {
    const env = process.env.NODE_ENV || 'development'; // Default to development if NODE_ENV is not set
    const command = `npx sequelize-cli db:migrate --env ${env}`;

    try {
        exec(command, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error executing migration: ${error}`);
                throw error;
            }
            console.log(`Migration output: ${stdout}`);
            if (stderr) {
                console.error(`Migration stderr: ${stderr}`);
            }
        });
    } catch (error) {
        console.error('Error running migrations:', error);
    }
}

module.exports = runMigrations;
