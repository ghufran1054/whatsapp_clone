const User = require('../models/user');
const jwt = require('jsonwebtoken');
module.exports = {
    requestOTP: async (req, res) => {
        //TODO: Implement OTP service later
        const { phone } = req.body;
        res.status(200).json({message: 'OTP sent'});
    },
    verifyOTP: async (req, res) => {
        //TODO: Implement OTP service later
        const { otp, phone } = req.body;
        

        if (otp === '123456') {
            const user = await User.findOne({phone});
            
            user == null ? res.status(200).json({message: 'OTP verified', next: 'sign-up'}) : res.status(200).json({message: 'OTP verified', next: 'login'});
        }
        else {
            res.status(400).json({message: 'OTP not verified'});
        }
    },
    login: async (req, res) => {
        const {phone} = req.body;
        const user = await User.findOne({phone});
        if(!user){
            res.status(400).json({message: 'User not found'});
        }
        const token = jwt.sign({id: user._id}, process.env.JWT_SECRET);
        res.status(200).json({...(user._doc), token});
    },
    signup: async (req, res) => {
        const {name, about, phone, profilePicUrl} = req.body;
        const user = new User({name, about, phone, profilePicUrl});
        await user.save();
        const token = jwt.sign({id: user._id}, process.env.JWT_SECRET);
        res.status(200).json({...(user._doc), token});
    },
}