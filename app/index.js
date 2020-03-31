require('dotenv').config();

const express = require('express');
const bodyParser = require('body-parser');
const db = require('./queries.js');
const app = express();
const port = process.env.APP_PORT

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

app.get('/app', (req, res) => res.json({ info: 'Got /app'}))

app.get('/users', db.getUsers)

app.listen(port, () => console.log(`My api running on port ${port}!`))
