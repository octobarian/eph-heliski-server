'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    return queryInterface.addColumn(
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
  },

  down: async (queryInterface, Sequelize) => {
    return queryInterface.removeColumn('trip_groups', 'guide_additional_id');
  }
};
