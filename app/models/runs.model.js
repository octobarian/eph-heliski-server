module.exports = (sequelize, Sequelize) => {
    const Run = sequelize.define("run", {
        runid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        runname: {
            type: Sequelize.STRING,
            allowNull: false
        },
        zoneid: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'zones',
                key: 'id' 
            }
        },
        runzone: {
            type: Sequelize.STRING,
            allowNull: true
        },
        startelevation: {
            type: Sequelize.FLOAT,
            allowNull: true
        },
        endelevation: {
            type: Sequelize.FLOAT,
            allowNull: true
        },
        isplaceholder: {
            type: Sequelize.BOOLEAN,
            allowNull: true
        }
    },{
        tableName: 'runs',
        timestamps: false
    });

    // Define associations here if any, for example:
    Run.associate = models => {
        Run.belongsTo(models.Zone, {
            foreignKey: 'zoneid',
            as: 'zone'
        });
        // Add other associations as necessary
    };

    return Run;
};
