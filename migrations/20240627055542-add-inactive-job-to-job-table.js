'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Add 'inactive' job title if it does not exist
    const [results, metadata] = await queryInterface.sequelize.query(
      `SELECT 1 FROM job WHERE jobtitle = 'inactive'`
    );

    if (results.length === 0) {
      await queryInterface.bulkInsert('job', [{ jobtitle: 'inactive' }], {});
    }
  },

  down: async (queryInterface, Sequelize) => {
    // Remove 'inactive' job title if it exists
    await queryInterface.bulkDelete('job', { jobtitle: 'inactive' }, {});
  }
}; 
