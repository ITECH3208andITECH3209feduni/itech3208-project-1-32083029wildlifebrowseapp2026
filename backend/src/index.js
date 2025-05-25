const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

// Import test data
const animalRequests = require('./test_data');

// homepage route (DELETE AFTER TESTING)
// This is a placeholder route to test if the server is running
app.get('/', (req, res) => {
  res.send('Welcome to the Browse App Request API!');
});

// Get all browse requests
app.get('/api/requests', (req, res) => {
  res.json(animalRequests);
});

// Create a new request
app.post('/api/requests', (req, res) => {
  const newRequest = req.body;
  animalRequests.push(newRequest);
  res.status(201).json({ message: 'Animal request added', data: newRequest });
});

app.listen(port, () => {
  console.log(`Animal API running at http://localhost:${port}`);
});