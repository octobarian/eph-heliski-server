module.exports = (sequelize, Sequelize) => {
    const TripShuttle = sequelize.define("tripShuttle", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        trip_id: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'trips', // References the "trips" table
                key: 'tripid'
            },
            onDelete: 'CASCADE'
        },
        shuttle_id: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'shuttles', // References the "shuttles" table
                key: 'id'
            },
            onDelete: 'CASCADE'
        },
        tripclientid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'tripclient', // References the "tripclient" table
                key: 'tripclientid'
            },
            onDelete: 'CASCADE'
        },
        dropoff_location: {
            type: Sequelize.STRING,
            allowNull: true
        },
        arrival_time: {
            type: Sequelize.TIME,
            allowNull: true
        },
        flight_time: {
            type: Sequelize.TIME,
            allowNull: true
        },
        pickup_location: {
            type: Sequelize.STRING,
            allowNull: true
        }
    },{
        tableName: 'trip_shuttles',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    TripShuttle.associate = (models) => {
        TripShuttle.belongsTo(models.trips, { foreignKey: 'trip_id' });
        TripShuttle.belongsTo(models.shuttles, { foreignKey: 'shuttle_id' });
        TripShuttle.belongsTo(models.tripClients, { foreignKey: 'tripclientid' });
    };

    return TripShuttle;
};
