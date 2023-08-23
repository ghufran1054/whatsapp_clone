const app = require('express')()
require('dotenv').config()
const mongoose = require('mongoose')
const bodyParser = require('body-parser')
const server = require('http').Server(app)
const socketIo = require('socket.io');
const chatSocket = require('./socket/socket')
const authRouter = require('./routes/auth')
const userRouter = require('./routes/user')
const chatRouter = require('./routes/chat')



//Running Socket io
const io = socketIo(server);
chatSocket(io);

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

app.use('/auth', authRouter)
app.use('/user', userRouter)
app.use('/chat', chatRouter)

app.get('/', async (req, res) => {
    res.send('Welcome to the server');
})

const PORT = process.env.PORT || 3000
const MONGO_URL = process.env.MONGO_URL


mongoose.connect(MONGO_URL);
db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => console.log('Connected to MongoDB'));



server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}.`)
});

