// tripStaff.model.js
module.exports = (sequelize, Sequelize) => {
    const TripStaff = sequelize.define("tripstaff", {
        tripstaffid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        tripid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'trips',
                key: 'tripid'
            }
        },
        staffid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'staffs',
                key: 'staffid'
            }
        },
        // Include any additional fields here
    },{
        tableName: 'tripstaff',
        timestamps: false // Assuming you don't have createdAt and updatedAt
    });

    return TripStaff;
};
