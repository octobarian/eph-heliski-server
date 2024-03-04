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
      }
    }, {
      tableName: 'tripclient',
      timestamps: false
    });
  
    return TripClient;
  };
  