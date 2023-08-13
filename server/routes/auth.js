const router = require('express').Router();
const authController = require('../controllers/auth');

router.post('/request-otp', authController.requestOTP);
router.post('/verify-otp', authController.verifyOTP);
router.post('/sign-up', authController.signup);
router.post('/login', authController.login);

module.exports = router;