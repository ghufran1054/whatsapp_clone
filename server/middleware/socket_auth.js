const jwt = require('jsonwebtoken');

authenticate = (socket, next) => {
    const token = socket.handshake.headers['authorization']; // Retrieve token from headers
  
    if (!token) {
      
      return next(new Error('Unauthorized: No token provided'));
    }
  
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      socket.userId = decoded.id; // Attach user ID to socket for reference
      
      return next();
    } catch (error) {
      return next(new Error('Unauthorized: Invalid token'));
    }
  }
module.exports = {authenticate};