module.exports = (sequelize, Sequelize) => {
    const TripClient = sequelize.define('TripClient', {
      tripclientid: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      tripid: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'trips',
          key: 'tripid'
        }
      },
      clientid: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'client', // Ensure this matches the table name for the client
          key: 'clientid'
        }
      },
      reservationid: {
        type: Sequelize.INTEGER,
        allowNull: true, // Allow null if a reservation is not always required
        references: {
          model: 'reservation',
          key: 'reservationid'
        }
      },
      trip_group_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
            model: 'TripGroup',
            key: 'trip_group_id'
        }
      },
    }, {
      tableName: 'tripclient',
      timestamps: false
    });
  
    TripClient.associate = models => {
      // Adjust the association, remove the one with trips and replace with trip groups
      TripClient.belongsTo(models.TripGroup, {
          foreignKey: 'trip_group_id',
          as: 'tripGroup'
      });
  };

    return TripClient;
  };
  