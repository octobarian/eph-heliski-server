module.exports = (sequelize, Sequelize) => {
    const TripRun = sequelize.define("triprun", {
        triprunid: {
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
        runid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'runs',
                key: 'runid'
            }
        },
        trip_group_id: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'trip_groups',
                key: 'trip_group_id'
            }
        },
        numberofguests: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        isplaceholder: {
            type: Sequelize.BOOLEAN,
            allowNull: true
        }
    },{
        tableName: 'tripruns',
        timestamps: false
    });

    TripRun.associate = models => {
        TripRun.belongsTo(models.Trip, {
            foreignKey: 'tripid',
            as: 'trip'
        });
        TripRun.belongsTo(models.Run, {
            foreignKey: 'runid',
            as: 'run'
        });
        TripRun.belongsTo(models.TripGroup, {
            foreignKey: 'trip_group_id',
            as: 'tripGroup'
        });
    };

    return TripRun;
};
