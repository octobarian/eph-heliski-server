const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const db = require('../app/models');
const UserLogin = db.user_logins; // Make sure this matches your UserLogin model name

router.post('/', (req, res) => {
    const { email, password } = req.body;

    UserLogin.findOne({ where: { email } })
        .then(user => {
            if (!user) {
                return res.status(401).send({ message: 'Invalid email or password.' });
            }

            bcrypt.compare(password, user.password_hash, (err, isMatch) => {
                if (err) throw err;
                if (isMatch) {
                    req.session.userId = user.id;
                    req.session.role = user.role;
                    res.send({ authenticated: true, role: user.role, email: user.email });
                } else {
                    res.status(401).send({ message: 'Invalid email or password.' });
                }
            });
        })
        .catch(err => {
            console.error(err);
            res.status(500).send({ message: 'Internal server error.' });
        });
});

module.exports = router; 

