module.exports = (sequelize, Sequelize) => {
    const Trip = sequelize.define("trip", {
        tripid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        pilotid: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'staff', // Assuming the pilot is a type of staff, and 'staff' is the table name
                key: 'staffid'
            }
        },
        date: {
            type: Sequelize.DATE,
            allowNull: false
        },
        start_date: {
            type: Sequelize.DATE,
            allowNull: false
        },
        end_date: {
            type: Sequelize.DATE,
            allowNull: false
        },
        totalvertical: {
            type: Sequelize.INTEGER,
            allowNull: true
        },
        isplaceholder: {
            type: Sequelize.BOOLEAN,
            allowNull: false,
            defaultValue: false
        },
        helicopterid: {
            type: Sequelize.INTEGER,
            allowNull: true, // Set to false if helicopterid should always be present
            references: {
                model: 'helicopter',
                key: 'helicopterid'
            }
        },
        noteid: {
            type: Sequelize.INTEGER,
            references: {
                model: 'notes', // 'notes' refers to table name
                key: 'noteid',   // 'noteid' refers to column name in notes table
            }
        },
        triptype: {
            type: Sequelize.STRING,
            allowNull: true
        },
        sortingindex: {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 1
        }
    },{
        tableName: 'trips',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    Trip.associate = models => {
        Trip.belongsTo(models.Staff, {
            foreignKey: 'pilotid',
            as: 'pilot'
        });
        Trip.belongsTo(models.Helicopter, {
            foreignKey: 'helicopterid',
            as: 'helicopter'
        });
        Trip.hasMany(models.TripStaff, {
            foreignKey: 'tripid',
            as: 'tripStaff'
        });
        Trip.hasMany(models.TripGroup, {
            foreignKey: 'trip_id',
            as: 'tripGroups'
        });
    };

    return Trip;
};
