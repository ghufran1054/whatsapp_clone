const MessageQueue = require("../models/message_queue");
module.exports = {
  /**
   *
   * @param {String} userId
   * @returns {Promise<[]>}
   */
  getQueueMessages: async (userId) => {
    try {
      const messageQueue = await MessageQueue.findOne({ userId: userId }).populate("messages").exec();
      if (!messageQueue) {
        return [];
      }
      return messageQueue.messages;
    } catch (err) {
      console.log(err);
    }
    return [];
  },
  /**
   * @param {[]} receivers
   */
  pushMessage: async (messageId, receivers) => {
    try {
      //for each member, create a message queue model if it doesn't exist and save it
      receivers.forEach(async (receiver) => {
        const messageQueue = await MessageQueue.findOne({ userId: receiver });
        if (!messageQueue) {
          const newMessageQueue = new MessageQueue({
            userId: receiver,
            messages: [messageId],
          });
          await newMessageQueue.save();
        } else {
          messageQueue.messages.push(messageId);
          await messageQueue.save();
        }
      });
    } catch (err) {
      console.log(err);
    }
  },
};
