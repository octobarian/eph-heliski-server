module.exports = (sequelize, Sequelize) => {
    const Shuttle = sequelize.define("shuttle", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        shuttlename: {
            type: Sequelize.STRING,
            allowNull: false
        },
        staffid: {
            type: Sequelize.INTEGER,
            allowNull: true,
            references: {
                model: 'staff', // Assuming 'staff' is the table name
                key: 'staffid'
            }
        },
        description: {
            type: Sequelize.STRING,
            allowNull: true
        }
    },{
        tableName: 'shuttles',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    // Define associations here if any, for example:
    Shuttle.associate = models => {
        Shuttle.belongsTo(models.Staff, {
            foreignKey: 'staffid',
            as: 'staff'
        });
        // Add other associations as necessary
    };

    return Shuttle;
};
