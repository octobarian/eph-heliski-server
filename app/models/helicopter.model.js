module.exports = (sequelize, Sequelize) => {
    const Helicopter = sequelize.define("helicopter", {
        helicopterid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        fuelamounttotal: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        weight: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        model: {
            type: Sequelize.STRING,
            allowNull: false
        },
        callsign: {
            type: Sequelize.STRING,
            allowNull: false
        },
        maxweight: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        // Add any additional fields here as needed
    },{
        tableName: 'helicopters',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    // Define associations here if any, for example:
    Helicopter.associate = models => {
        Helicopter.hasMany(models.Trip, {
            foreignKey: 'helicopterid',
            as: 'trips'
        });
        // Add other associations as necessary
    };

    return Helicopter;
};
