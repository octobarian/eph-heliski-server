module.exports = (sequelize, Sequelize) => {
    const Person = sequelize.define("person", {
        personid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        firstname: Sequelize.STRING,
        lastname: Sequelize.STRING,
        mobilephone: Sequelize.STRING,
        email: Sequelize.STRING,
        country: Sequelize.STRING,
        dateofbirth: Sequelize.DATEONLY,
        weight: Sequelize.DECIMAL,
        isplaceholder: Sequelize.BOOLEAN
    },{
        tableName: 'person',
        timestamps: false,
    });
    
    return Person;
};
