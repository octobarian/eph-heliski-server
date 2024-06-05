// TrainingType.model.js
module.exports = (sequelize, Sequelize) => {
    const TrainingType = sequelize.define("trainingtype", {
        trainingtypeid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        trainingname: {
            type: Sequelize.STRING,
            allowNull: false
        },
        expiretime: {
            type: Sequelize.STRING,
            allowNull: false
        }
    }, {
        tableName: 'trainingtype',
        timestamps: false
    });
  
    return TrainingType; 
};
