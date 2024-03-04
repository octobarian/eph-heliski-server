module.exports = (sequelize, Sequelize) => {
    const PersonHealth = sequelize.define("personhealth", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: Sequelize.INTEGER,
        healthrecordvalueid: Sequelize.INTEGER,
        severityid: Sequelize.INTEGER,
        isplaceholder: Sequelize.BOOLEAN,
        description: Sequelize.STRING
    }, {
        tableName: 'personhealth',
        timestamps: false
    });

    // Define associations
    PersonHealth.associate = models => {
        PersonHealth.belongsTo(models.Person, {
            foreignKey: 'personid',
            as: 'person'
        });

        PersonHealth.belongsTo(models.HealthRecordValues, {
            foreignKey: 'healthrecordvalueid',
            as: 'healthrecordvalue'
        });

        PersonHealth.belongsTo(models.HealthSeverities, {
            foreignKey: 'severityid',
            as: 'severity'
        });
    };

    return PersonHealth;
};
