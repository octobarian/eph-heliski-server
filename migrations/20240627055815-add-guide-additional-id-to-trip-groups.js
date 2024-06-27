'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Check if the column exists
    const tableDescription = await queryInterface.describeTable('trip_groups');
    if (!tableDescription.guide_additional_id) {
      await queryInterface.addColumn(
        'trip_groups', // name of the target table
        'guide_additional_id', // name of the new column
        {
          type: Sequelize.INTEGER,
          allowNull: true,
          references: {
            model: 'staff', // name of the referenced table
            key: 'staffid', // primary key of the referenced table
          }
        }
      );
    }
  },

  down: async (queryInterface, Sequelize) => {
    // Remove the column if it exists
    const tableDescription = await queryInterface.describeTable('trip_groups');
    if (tableDescription.guide_additional_id) {
      await queryInterface.removeColumn('trip_groups', 'guide_additional_id');
    }
  }
};
