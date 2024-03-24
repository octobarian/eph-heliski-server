module.exports = (sequelize, Sequelize) => {
    const CustomFieldOptions = sequelize.define("custom_field_options", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        field_name: {
            type: Sequelize.STRING,
            allowNull: false
        }
    },{
        tableName: 'custom_field_options',
        timestamps: false,
    });

    return CustomFieldOptions;
};
