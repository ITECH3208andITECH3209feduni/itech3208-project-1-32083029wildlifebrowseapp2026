const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());  

// Database connection config
const pool = new Pool({
  user: 'postgres',
  host: 'localhost', 
  database: 'postgres',
  password: '123',
  port: 8000
});

// Flutter Commands
app.post('/create-delivery', async (req, res) => {
  const client = await pool.connect();

  try {
    const { name, address, specifications,animal_ID, items } = req.body;

    // Map JavaScript objects to PostgreSQL composite type text format
    const pgItemsArray = items.map(item => `(${item.plant_ID},${item.quantity})`);

    const result = await client.query(
      `SELECT create_full_delivery($1, $2, $3, $4, $5::delivery_item_type[]) AS delivery_id`,
      [name, address, specifications,animal_ID, pgItemsArray]
    );

    const delivery_ID = result.rows[0].delivery_id;
    res.status(201).send({ message: 'Delivery Created', delivery_ID });

  } catch (error) {
    console.error("Error processing delivery:", error);
    res.status(500).send('Server error while creating delivery.');
  } finally {
    client.release();
  }
});

try {
  app.listen(3000, '0.0.0.0', () => {
    console.log('Node.js server listening on port 3000');
  });
} catch (error) {
  console.error('Error starting server:', error);
}