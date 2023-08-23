const router = require('express').Router();
const chatController = require('../controllers/chat');

router.post('/create', chatController.createChat);


module.exports = router;