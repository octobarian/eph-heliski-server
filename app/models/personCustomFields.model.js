module.exports = (sequelize, Sequelize) => {
    const PersonCustomFields = sequelize.define("person_custom_fields", {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'person', // 'person' refers to table name
                key: 'personid', // 'personid' refers to column name in persons table
            }
        },
        field_name: {
            type: Sequelize.STRING,
            allowNull: false
        },
        field_value: {
            type: Sequelize.STRING,
            allowNull: true
        }
    },{
        tableName: 'person_custom_fields',
        timestamps: false,
    });
    
    return PersonCustomFields;
};
