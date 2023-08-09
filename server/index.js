const app = require('express')()
require('dotenv').config()
const mongoose = require('mongoose')
const PORT = process.env.PORT || 3000
const MONGO_URL = process.env.MONGO_URL


mongoose.connect(MONGO_URL);
db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => console.log('Connected to MongoDB'));



app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}.`)
})


