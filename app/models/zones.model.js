module.exports = (sequelize, Sequelize) => {
    const Zone = sequelize.define("zone", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        zonename: {
            type: Sequelize.STRING,
            allowNull: false
        },
        description: {
            type: Sequelize.STRING,
            allowNull: true
        }
    },{
        tableName: 'zones',
        timestamps: false
    });

    // Define associations here if any, for example:
    Zone.associate = models => {
        Zone.hasMany(models.Run, {
            foreignKey: 'zoneid',
            as: 'runs'
        });
        // Add other associations as necessary
    };

    return Zone;
};
