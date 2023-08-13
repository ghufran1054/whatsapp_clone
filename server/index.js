const app = require('express')()
require('dotenv').config()
const mongoose = require('mongoose')
const authRouter = require('./routes/auth')
const bodyParser = require('body-parser')
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

app.use('/auth', authRouter)
app.get('/', async (req, res) => {
    res.send('Welcome to the server');
})

const PORT = process.env.PORT || 3000
const MONGO_URL = process.env.MONGO_URL


mongoose.connect(MONGO_URL);
db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => console.log('Connected to MongoDB'));



app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}.`)
})


