const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    req.session.destroy(err => {
        if (err) {
            return res.status(500).send({ message: 'Failed to log out.' });
        }
        res.clearCookie('connect.sid');
        res.send({ message: 'Logged out successfully.' });
    });
});

module.exports = router;
