module.exports = (sequelize, Sequelize) => {
    const Note = sequelize.define("note", {
        noteid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        text: {
            type: Sequelize.TEXT,
            allowNull: false
        },
        createdAt: {
            type: Sequelize.DATE,
            defaultValue: Sequelize.NOW
        }
    });

    return Note;
};
