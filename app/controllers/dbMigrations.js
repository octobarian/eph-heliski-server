const { sequelize } = require('../models'); // Adjust the path to your Sequelize instance
const fs = require('fs');
const path = require('path');

async function runMigrations() {
    const migrationsDir = path.join(__dirname, '../migrations-sql');
    
    try {
        const files = fs.readdirSync(migrationsDir).filter(file => file.endsWith('.sql'));
        
        for (const file of files) {
            const filePath = path.join(migrationsDir, file);
            const migrationQuery = fs.readFileSync(filePath, 'utf8');
            
            try {
                await sequelize.query(migrationQuery);
                console.log(`Migration ${file} executed successfully`);
            } catch (error) {
                console.error(`Error executing migration ${file}:`, error);
                throw error; // Stop further execution if any migration fails
            }
        }
    } catch (error) {
        console.error('Error reading migration files:', error);
    }
}

module.exports = runMigrations;
