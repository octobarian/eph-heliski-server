module.exports = (sequelize, Sequelize) => {
    const HealthSeverities = sequelize.define("healthseverities", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        isplaceholder: Sequelize.BOOLEAN,
        shortform: Sequelize.STRING,
        description: Sequelize.STRING
    }, {
        tableName: 'healthseverities',
        timestamps: false
    });

    return HealthSeverities;
};
