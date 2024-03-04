module.exports = (sequelize, DataTypes) => {
    const Reservation = sequelize.define("reservation", {
        reservationid: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        personid: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
        groupcode: {
            type: DataTypes.STRING,
            allowNull: true
        },
        activitydate: {
            type: DataTypes.DATEONLY,
            allowNull: false
        },
        balanceowing: {
            type: DataTypes.DECIMAL(10, 2),
            allowNull: true
        },
        createdat: {
            type: DataTypes.DATE,
            defaultValue: DataTypes.NOW
        },
        updatedat: {
            type: DataTypes.DATE,
            defaultValue: DataTypes.NOW
        },
        zauireservationid:{
            type: DataTypes.INTEGER,
            allowNull: true
        },
        isplaceholder: {
            type: DataTypes.BOOLEAN,
            defaultValue: false
        }
        // Add other fields as necessary
    }, {
        tableName: 'reservation',
        timestamps: false // if you don't have createdAt and updatedAt columns
    });

    //reservation associations
    Reservation.associate = models => {
        Reservation.belongsTo(models.Person, {
            foreignKey: 'personid',
            as: 'person'
        });

        Reservation.hasMany(models.ReservationDetails, {
            foreignKey: 'reservationid',
            as: 'details'
        });
        Reservation.hasMany(models.TripClient, {
            foreignKey: 'reservationid',
            as: 'tripClients'
        });
    };

    return Reservation;
};
