module.exports = (sequelize, DataTypes) => {
    const Wildlife = sequelize.define('Wildlife', {
        wildlifeid: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        runid: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'runs',
                key: 'runid'
            }
        },
        tripgroupid: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: 'trip_groups',
                key: 'trip_group_id'
            }
        },
        type: {
            type: DataTypes.STRING,
            allowNull: false
        },
        comments: {
            type: DataTypes.STRING,
            allowNull: true
        },
        species: {
            type: DataTypes.STRING,
            allowNull: false
        },
        observerid: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'persons',
                key: 'personid'
            }
        },
        sightingdetails: {
            type: DataTypes.STRING,
            allowNull: true
        },
        isplaceholder: {
            type: DataTypes.BOOLEAN,
            defaultValue: false
        },
        spottedtime: {
            type: DataTypes.DATE,
            allowNull: true
        }
    },{
        tableName: 'wildlife',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    Wildlife.associate = models => {
        Wildlife.belongsTo(models.Run, {
            foreignKey: 'runid',
            as: 'run'
        });
        Wildlife.belongsTo(models.TripGroup, {
            foreignKey: 'tripgroupid',
            as: 'tripGroup'
        });
        Wildlife.belongsTo(models.Person, {
            foreignKey: 'observerid',
            as: 'observer'
        });
    };

    return Wildlife;
};
