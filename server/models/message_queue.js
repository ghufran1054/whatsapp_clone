const mongoose = require('mongoose')
const Schema = mongoose.Schema;


const messageQueueSchema = new Schema({
    userId:{
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    messages: [{
        type: Schema.Types.ObjectId,
        ref: 'Message',
    }],
});

const MessageQueue = mongoose.model('MessageQueue', messageQueueSchema);
module.exports = MessageQueue;