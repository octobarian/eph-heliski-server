module.exports = (sequelize, Sequelize) => {
    const ZauiDailyManifests = sequelize.define("Zaui_Daily_Manifests", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        manifestdate: {
            type: Sequelize.DATEONLY,
            allowNull: false,
            unique: true // Ensure manifestdate is unique
        },
        response: {
            type: Sequelize.JSONB, // Updated to use JSONB type
            allowNull: false // Updated based on your table structure to not allow nulls
        }
    },{
        tableName: 'zaui_daily_manifests',
        timestamps: false,
    });
    
    return ZauiDailyManifests;
};
