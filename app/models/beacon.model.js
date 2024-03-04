module.exports = (sequelize, DataTypes) => {
    const Beacon = sequelize.define('Beacon', {
        beaconid: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        beaconnumber: {
            type: DataTypes.STRING,
        },
        tripclientid: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: 'tripclient',
                key: 'tripclientid'
            }
        },
        active: {
            type: DataTypes.BOOLEAN,
            defaultValue: true
        },
        notes: {
            type: DataTypes.STRING,
            allowNull: true,
        }
        
    },{
        tableName: 'beacons',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    Beacon.associate = models => {
        Beacon.belongsTo(models.TripClient, {
            foreignKey: 'tripclientid',
            as: 'tripclient'
        });
    };

    return Beacon;
};
