module.exports = (sequelize, Sequelize) => {
    const TripGroup = sequelize.define('TripGroup', {
        trip_group_id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        trip_id: { // Foreign key to 'trips' table
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'trips', // This should match the table name as defined in Sequelize
                key: 'tripid'
            }
        },
        guide_id: { // Foreign key to 'staff' table
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'staff', // This should match the table name as defined in Sequelize
                key: 'staffid'
            }
        }
        // Add other attributes like group name, level, etc., if needed
    }, {
        tableName: 'trip_groups',
        timestamps: false
    });

    TripGroup.associate = models => {
        TripGroup.belongsTo(models.Trip, {
            foreignKey: 'trip_id',
            as: 'trip'
        });
        TripGroup.belongsTo(models.Staff, {
            foreignKey: 'guide_id',
            as: 'guide'
        });
        TripGroup.hasMany(models.TripClient, {
            foreignKey: 'trip_group_id',
            as: 'tripClients'
        });
    };

    return TripGroup;
};
