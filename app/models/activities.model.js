module.exports = (sequelize, DataTypes) => {
    const Activities = sequelize.define('activities', {
      activityid: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      zauiactivityid: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
      },
      activityname: {
        type: DataTypes.TEXT,
        allowNull: false
      }
    },{
        tableName: 'activities',
        timestamps: false
    });
    return Activities;
  };
  