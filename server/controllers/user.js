const User = require("../models/user");

module.exports = {
  getUsersFromPhone: async function (req, res) {
    try {
      const { phoneNumbers } = req?.body;
      if (!phoneNumbers) {
        return res
          .status(400)
          .send({ message: "Bad Request, phoneNumbers is required" });
      }
      if (phoneNumbers.length === 0) {
        return res.send({ users: [] });
      }
      const users = await User.find({ phone: { $in: phoneNumbers } });
      res.send({ users });
    } catch (err) {
      console.log(err);z
      res.status(500).send({ message: err.message });
    }
  },
};
