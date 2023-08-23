const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const chatSchema = new Schema({
  isGroup: {
    type: Boolean,
    default: false,
  },
  // unreadCount: Number,
  // lastMessageString: String,
  // lastMessageTime: String,
  // lastSeen: Date, we don't need this because these are all based on the messages and the end user
  members: [
    {
      type: Schema.Types.ObjectId,
      ref: "User",
    },
  ],
  groupData: {
    name: String,
    description: String,
    groupPicUrl: String,
    createdOn: Date,
    createdBy: {
      type: Schema.Types.ObjectId,
      ref: "User",
    },
    admins: [
      {
        type: Schema.Types.ObjectId,
        ref: "User",
      },
    ],
  },
});

const Chat = mongoose.model("Chat", chatSchema);
module.exports = Chat;
