'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Check if the column exists
    const tableDescription = await queryInterface.describeTable('beacons');
    if (!tableDescription.inspectiondate) {
      await queryInterface.addColumn(
        'beacons', // name of the target table
        'inspectiondate', // name of the new column
        {
          type: Sequelize.DATE,
          allowNull: true,
        }
      );
    }
  },

  down: async (queryInterface, Sequelize) => {
    // Remove the column if it exists
    const tableDescription = await queryInterface.describeTable('beacons');
    if (tableDescription.inspectiondate) {
      await queryInterface.removeColumn('beacons', 'inspectiondate');
    }
  }
};
