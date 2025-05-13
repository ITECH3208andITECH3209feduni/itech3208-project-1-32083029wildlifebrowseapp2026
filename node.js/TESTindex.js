const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');
const cors = require('cors');
const { body, validationResult } = require('express-validator');

const app = express();
const PORT = 3000;
const HOST = '0.0.0.0';

// Enable CORS for all origins
app.use(cors());
// Parse JSON request bodies
app.use(express.json());
app.use(bodyParser.json()); // Redundant with express.json(), but kept for potential older middleware dependencies

// Database connection configuration
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'postgres',
    password: '123',
    port: 8000
});

// Test database connection on server start
pool.connect()
    .then(() => {
        console.log('\x1b[32m[Database]\x1b[0m Successfully connected to PostgreSQL.');
    })
    .catch((err) => {
        console.error('\x1b[31m[Database Error]\x1b[0m Error connecting to PostgreSQL:', err.message);
        // It's critical to handle this error, potentially exit the application
        process.exit(1);
    });

/**
 * @route   POST /create-delivery
 * @desc    Creates a new delivery record in the database.
 * @access  Public (assuming no specific authentication implemented)
 */
app.post(
    '/create-delivery',
    // Data validation middleware
    [
        body('name').notEmpty().withMessage('Name is required.'),
        body('address').notEmpty().withMessage('Address is required.'),
        body('animal_ID').isInt({ min: 1 }).withMessage('Animal ID must be a positive integer.'),
        body('items').isArray({ min: 1 }).withMessage('At least one item is required.'),
        body('items.*.plant_ID').isInt({ min: 1 }).withMessage('Each item must have a positive integer Plant ID.'),
        body('items.*.quantity').isInt({ min: 1 }).withMessage('Each item quantity must be a positive integer.'),
    ],
    async (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const client = await pool.connect();

        try {
            const { name, address, specifications, animal_ID, items } = req.body;

            // Map JavaScript objects to PostgreSQL composite type text format
            const pgItemsArray = items.map(item => `(${item.plant_ID},${item.quantity})`);

            const result = await client.query(
                `SELECT create_full_delivery($1, $2, $3, $4, $5::delivery_item_type[]) AS delivery_id`,
                [name, address, specifications, animal_ID, pgItemsArray]
            );

            if (result.rows.length > 0 && result.rows[0].delivery_id) {
                const deliveryID = result.rows[0].delivery_id;
                console.log('\x1b[32m[Delivery]\x1b[0m Delivery created successfully. Delivery ID:', deliveryID);
                res.status(201).json({ message: 'Delivery Created', delivery_ID: deliveryID });
            } else {
                console.error('\x1b[31m[Delivery Error]\x1b[0m Failed to retrieve delivery ID after creation.');
                res.status(500).send('Server error: Failed to create delivery or retrieve ID.');
            }

        } catch (error) {
            console.error('\x1b[31m[Delivery Error]\x1b[0m Error processing delivery:', error.message);
            // Optionally log the full error stack for detailed debugging
            // console.error(error);
            res.status(500).send('Server error while creating delivery.');
        } finally {
            client.release();
        }
    }
);
