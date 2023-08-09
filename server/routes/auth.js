const router = require('express').Router();
const authController = require('../controllers/auth');

router.post('/request-otp', authController.requestOTP);
router.post('/verify-otp', authController.verifyOTP);