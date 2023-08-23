const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const messageSchema = new Schema({
    chatId:{
        type: Schema.Types.ObjectId,
        ref: 'Chat'
    },
    senderId:{
        type: Schema.Types.ObjectId,
        ref: 'User'
    },
    messageType: String,
    content: String,
    fileUrl: {
        type: String,
        default: null,
    },
    createdAt: Date,
    readBy: [
        {
          user_id: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User' // Reference to the User model
          },
          readAt: Date
        }
      ],
      deliveredTo: [
        {
          user_id: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User' // Reference to the User model
          },
          deliveredAt: Date
        }
      ]
});

const Message = mongoose.model('Message', messageSchema);
module.exports = Message;