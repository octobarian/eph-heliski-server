module.exports = (sequelize, DataTypes) => {
    const ReservationDetails = sequelize.define("reservationDetails", {
        reservationdetailid: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        reservationid: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'reservations',
                key: 'reservationid'
            }
        },
        activityid: {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
              model: 'activities',
              key: 'activityid'
            }
        },
        vanpickup: {
            type: DataTypes.BOOLEAN,
            allowNull: true
        },
        firstskitripofyear: {
            type: DataTypes.BOOLEAN,
            allowNull: true
        },
        newguest: {
            type: DataTypes.BOOLEAN,
            allowNull: true
        },
        arrivingtorevelstoke: {
            type: DataTypes.STRING,
            allowNull: true
        },
        ad2: {
            type: DataTypes.STRING,
            allowNull: true
        },
        isplaceholder: {
            type: DataTypes.BOOLEAN,
            defaultValue: false,
            allowNull: true
        }
    }, {
        tableName: 'reservationdetails',
        timestamps: false
    });
    
    ReservationDetails.associate = models => {
        ReservationDetails.belongsTo(models.Reservation, {
            foreignKey: 'reservationid',
            as: 'reservation'
        });
    };

    return ReservationDetails;
};
