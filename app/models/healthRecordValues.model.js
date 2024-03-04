module.exports = (sequelize, Sequelize) => {
    const HealthRecordValues = sequelize.define("healthrecordvalues", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        healthrecordtypeid: Sequelize.INTEGER,
        isplaceholder: Sequelize.BOOLEAN,
        shortform: Sequelize.STRING,
        description: Sequelize.STRING
    }, {
        tableName: 'healthrecordvalues',
        timestamps: false
    });

    // Define associations
    HealthRecordValues.associate = models => {
        HealthRecordValues.belongsTo(models.HealthRecordTypes, {
            foreignKey: 'healthrecordtypeid',
            as: 'healthrecordtype'
        });
    };

    return HealthRecordValues;
};
