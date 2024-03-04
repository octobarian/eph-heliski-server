module.exports = (sequelize, Sequelize) => {
    const Job = sequelize.define("job", {
        jobid: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        jobtitle: {
            type: Sequelize.STRING,
            allowNull: false
        },
        // Add other fields here as per your table definition
    },{
        tableName: 'job',
        timestamps: false // Set to true if you have createdAt and updatedAt columns
    });

    // Associations can be defined here, for example, if jobs are linked to staff:
    Job.associate = models => {
        Job.hasMany(models.Staff, {
            foreignKey: 'jobid',
            as: 'staff'
        });
        // Include any other associations your database schema requires
    };

    return Job;
};
