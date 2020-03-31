require('dotenv').config();

const Pool = require('pg').Pool;

console.log(
  '\nDatabase: ' +
  '\n  host:     ' + process.env.DB_HOST +
  '\n  port:     ' + process.env.POSTGRES_PORT +
  '\n  database: ' + process.env.POSTGRES_DB +
  '\n  user:     ' + process.env.POSTGRES_USER
);

const pool = new Pool(
{
    host:     process.env.DB_HOST,
    port:     process.env.POSTGRES_PORT,
    database: process.env.POSTGRES_DB,
    user:     process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD
});

const getUsers = (req, res) => {
  pool.query('SELECT lastname, firstname FROM users ORDER BY lastname ASC', (error, results) => {
    if (error) {
      throw error
    }
    res.status(200).json(results.rows)
    })
  }

module.exports = { getUsers };
