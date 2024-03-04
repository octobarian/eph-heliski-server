module.exports = (sequelize, DataTypes) => {
    const ZauiStatus = sequelize.define("ZauiStatus", {
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        responsetime: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
        responsemessage: {
            type: DataTypes.STRING,
            allowNull: false
        },
        createdat: {
            type: DataTypes.DATE,
            defaultValue: DataTypes.NOW
        }
    }, {
        timestamps: false,
        tableName: 'zauistatuses'
    });

    return ZauiStatus;
};
