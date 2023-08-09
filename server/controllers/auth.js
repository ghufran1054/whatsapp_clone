const User = require('../models/user');
const jwt = require('jsonwebtoken');
module.exports = {
    requestOTP: async (req, res) => {
        //TODO: Implement OTP service later
        res.status(200).json({message: 'OTP sent'});
    },
    verifyOTP: async (req, res) => {
        //TODO: Implement OTP service later
        const { otp } = req.body;
        if (otp === '123456') {
            res.status(200).json({message: 'OTP verified'});
        }
        else {
            res.status(400).json({message: 'OTP not verified'});
        }
    },
    login: async (req, res) => {
        const {name, about, phone} = req.body;
        const user = await User.findOne({phone});
        if(!user){
            const newUser = new User({
                name,
                about,
                phone
            });
            await newUser.save();
            const token = jwt.sign({id: newUser._id}, process.env.JWT_SECRET);

            //send back the newly created user and token to the client
            return res.status(200).json({user: newUser, token});
        }
        const token = jwt.sign({id: user._id}, process.env.JWT_SECRET);
        res.status(200).json({user, token});
    },
}