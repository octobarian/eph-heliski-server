module.exports = (sequelize, Sequelize) => {
    const HealthRecordTypes = sequelize.define("healthrecordtypes", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        shortform: Sequelize.STRING,
        description: Sequelize.STRING,
        isplaceholder: Sequelize.BOOLEAN,
    }, {
        tableName: 'healthrecordtypes',
        timestamps: false
    });

    return HealthRecordTypes;
};
