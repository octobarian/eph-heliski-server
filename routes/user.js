const express = require('express');
const router = express.Router();
const db = require('../app/models');
const UserLogin = db.user_logins;

router.get('/', (req, res) => {
    if (req.session.userId) {
        UserLogin.findByPk(req.session.userId)
            .then(user => {
                if (user) {
                    res.send({
                        authState: 'Authorized',
                        email: user.email,
                        role: user.role
                    });
                } else {
                    res.status(401).send({ authState: 'notAuthenticated' });
                }
            })
            .catch(err => {
                console.error(err);
                res.status(500).send({ message: 'Internal server error.' });
            });
    } else {
        res.status(401).send({ authState: 'notAuthenticated' });
    }
});

module.exports = router;
