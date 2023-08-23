const Chat = require("../models/Chat");
module.exports = {
  createChat: async (req, res) => {
    try {
      const { _id, id, chatUserId, ...restOfChat } = req.body;
      const chat = new Chat(restOfChat);
      console.log(req.body);
      const savedChat = await chat.save();
      res
        .status(200)
        .json({ message: "Chat created successfully", _id: savedChat._id, id });
    } catch (err) {
      console.log(err);
      res.status(500).json({ message: err.message });
    }
  },
};
