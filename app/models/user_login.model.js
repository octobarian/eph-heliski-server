module.exports = (sequelize, DataTypes) => {
    const UserLogin = sequelize.define('user_logins', {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true
        },
        email: {
            type: DataTypes.STRING,
            allowNull: false,
            unique: true
        },
        password_hash: {
            type: DataTypes.STRING,
            allowNull: false
        },
        role: {
            type: DataTypes.STRING,
            allowNull: false
        },
        staff_id: {
            type: DataTypes.INTEGER,
            references: {
                model: 'staff',
                key: 'staffid'
            }
        },
        created_at: {
            type: DataTypes.DATE,
            defaultValue: DataTypes.NOW
        },
        updated_at: {
            type: DataTypes.DATE,
            defaultValue: DataTypes.NOW
        }
    }, {
        timestamps: false,
        underscored: true
    });

    UserLogin.associate = function(models) {
        UserLogin.belongsTo(models.staff, { foreignKey: 'staff_id' });
    };

    return UserLogin;
};
