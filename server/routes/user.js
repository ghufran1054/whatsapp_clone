const router = require('express').Router();
const UserController = require('../controllers/user.js');

router.post('/getUsersFromPhone', UserController.getUsersFromPhone);

module.exports = router;