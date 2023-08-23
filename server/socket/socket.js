const auth = require("../middleware/socket_auth.js");
const messageController = require("../controllers/message.js");
const messageQueueController = require("../controllers/message_queue.js");

const userConnections = new Map();
/**
 *
 * @param {{}} message
 * @param {*} socket
 */

async function handleMessage(message, socket) {
  console.log("message: ", message);

  let savedMessage = await messageController.addMessage(message);
  savedMessage = await savedMessage.populate({
    path: "chatId",
    select: "members",
  });

  console.log("isPopulated: ", savedMessage.populated("chatId"));

  const members = savedMessage.chatId.members;
  const sender = savedMessage.senderId;
  console.log("sender: ", sender);
  const receivers = members.filter((member) => {
    return sender.equals(member);

  });
  console.log("receivers: ", receivers);

  const offlineReceivers = [];
  receivers.forEach((receiver) => {
    if (userConnections.has(receiver)) {
      userConnections.get(receiver).emit("message", savedMessage);
      savedMessage.deliveredTo.push(receiver);
    } else {
      offlineReceivers.push(receiver);
    }
  });

  if (offlineReceivers.length > 0) {
    messageQueueController.pushMessage(savedMessage, offlineReceivers);
  }
  savedMessage = await savedMessage.save();

  //Sending the response back to the sender that the message has successfully been saved
  const { createdAt, chatId, ...responseData } = savedMessage._doc;
  socket.emit("messageResponse", {
    id: message.id,
    createdAt: savedMessage.createdAt.toISOString(),
    chatId: chatId._id,
    ...responseData,
  });
}

async function sendQueuedMessages(socket) {
  const userId = socket.userId;
  const messages = await messageQueueController.getQueueMessages(userId);
  messages.forEach((message) => {
    message.deliveredTo.push(userId);
    message.save().then((savedMessage) => {
      const { createdAt, chatId, ...responseData } = savedMessage._doc;
      socket.emit("messageResponse", {
        createdAt: savedMessage.createdAt.toISOString(),
        chatId: chatId._id,
        ...responseData,
      });
    });
  });

}
const chatSocket = (io) => {
  console.log("chat socket started");
  io.use(auth.authenticate);
  io.on("connection", (socket) => {
    console.log(`a user connected ${socket.userId}`);
    userConnections[socket.userId] = socket;
    sendQueuedMessages(socket);

    socket.on("message", (message) => {
      handleMessage(message, socket);
    });

    socket.on("disconnect", () => {
      console.log(`user disconnected ${socket.userId}`);
      userConnections.delete(socket.userId);
    });
  });
};

module.exports = chatSocket;
