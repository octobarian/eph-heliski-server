module.exports = (sequelize, Sequelize) => {
    const TripGroup = sequelize.define('TripGroup', {
        trip_group_id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        trip_id: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'trips',
                key: 'tripid'
            }
        },
        start_date: {
            type: Sequelize.DATE,
            allowNull: false
        },
        end_date: {
            type: Sequelize.DATE,
            allowNull: false
        },
        guide_id: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'staff',
                key: 'staffid'
            }
        },
        guide_additional_id: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'staff',
                key: 'staffid'
            }
        },
        noteid: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'notes',
                key: 'noteid'
            }
        }
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
        TripGroup.belongsTo(models.Staff, {
            foreignKey: 'guide_additional_id',
            as: 'guideAdditional'
        });
        TripGroup.hasMany(models.TripClient, {
            foreignKey: 'trip_group_id',
            as: 'tripClients'
        });
    };

    return TripGroup;
};
