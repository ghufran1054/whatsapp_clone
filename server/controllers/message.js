const Message = require("../models/message");

module.exports = {
  addMessage: async (paramMessage) => {
    try {
      const { _id, id, status, ...restOfMessage } = paramMessage;
      const message = new Message(restOfMessage);
      const date = new Date();
      message.createdAt = date.toISOString();
      const savedMessage = await message.save();
      return savedMessage;
    } catch (err) {
      console.log(err);
    }
  },
};
