// PersonTraining.model.js
module.exports = (sequelize, Sequelize) => {
    const PersonTraining = sequelize.define("persontraining", {
        persontrainingid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'person',
                key: 'personid'
            }
        },
        trainingtypeid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'trainingtype',
                key: 'trainingtypeid'
            }
        },
        trainingfor: {
            type: Sequelize.STRING,
            allowNull: false
        },
        trainingdate: {
            type: Sequelize.DATE,
            allowNull: false
        },
        notes: {
            type: Sequelize.STRING,
            allowNull: true
        },
        isplaceholder: {
            type: Sequelize.BOOLEAN,
            defaultValue: false
        }
    }, {
        tableName: 'persontraining',
        timestamps: false
    });

    // Associations can be defined here if needed
    PersonTraining.associate = models => {
        PersonTraining.belongsTo(models.Person, {
            foreignKey: 'personid',
            as: 'person'
        });
    };

    return PersonTraining;
};
