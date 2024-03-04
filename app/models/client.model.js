module.exports = (sequelize, Sequelize) => {
    const Client = sequelize.define("client", {
        clientid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'person', // Ensure this matches the table name
                key: 'personid'
            }
        },
        // other fields like isplaceholder if needed
    },{
        tableName: 'client',
        timestamps: false // if you don't have createdAt and updatedAt columns
    });

    //Things which are linked to a client
    Client.associate = models => {
        Client.belongsTo(models.Person, {
            foreignKey: 'personid',
            as: 'person'
        });
    };

    return Client;
};
