module.exports = (sequelize, Sequelize) => {
    const Staff = sequelize.define("staff", {
        staffid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: {
            type: Sequelize.INTEGER,
            allowNull: false,
            references: {
                model: 'person', // This should match the table name for the person, as defined in your Sequelize model
                key: 'personid'
            }
        },
        jobid: {
            type: Sequelize.INTEGER,
            allowNull: false, // Change this to false if jobid should not be null
            references: {
                model: 'job', // This should match the table name for the job, as defined in your Sequelize model
                key: 'jobid'
            }
        },
        // You can add more fields here as needed, following the structure of your database
    },{
        tableName: 'staff',
        timestamps: false // Assuming you don't have createdAt and updatedAt columns
    });

    // Associations can be defined here if needed, for example:
    Staff.associate = models => {
        Staff.belongsTo(models.Person, {
            foreignKey: 'personid',
            as: 'person'
        });
        // If the staff has a relationship with the job table, define it here:
        Staff.belongsTo(models.Job, {
            foreignKey: 'jobid',
            as: 'job'
        });
        // Add other associations here as necessary
    };

    return Staff;
};
