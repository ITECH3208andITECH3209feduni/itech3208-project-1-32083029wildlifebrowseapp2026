import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";

import Request from "./models/Request.js";
import Landholder from "./models/Landholder.js";

dotenv.config();

const app = express();

app.use(cors({ origin: "*" }));
app.use(express.json());

const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(MONGO_URI)
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.log("❌ MongoDB Error:", err));

app.get("/", (req, res) => {
  res.send("Backend running 🚀");
});


// =======================
// REQUEST ROUTES
// =======================

// GET all requests
app.get("/requestsAPI", async (req, res) => {
  try {
    const requests = await Request.find();
    res.status(200).json({ items: requests });
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch requests" });
  }
});

// POST new request
app.post("/requestsAPI", async (req, res) => {
  try {
    const newRequest = new Request(req.body);
    await newRequest.save();

    res.status(201).json({
      message: "Request created successfully",
      items: [newRequest],
    });
  } catch (error) {
    res.status(500).json({ error: "Failed to create request" });
  }
});

// PATCH update request
app.patch("/requestsAPI/:request_ID/:status_Num", async (req, res) => {
  try {
    const { request_ID, status_Num } = req.params;

    const updatedRequest = await Request.findOneAndUpdate(
      { request_ID: request_ID },
      {
        ...req.body,
        status_Num: Number(status_Num),
      },
      { returnDocument: "after" }
    );

    if (!updatedRequest) {
      return res.status(404).json({ error: "Request not found" });
    }

    res.status(200).json({
      message: "Request updated successfully",
      items: [updatedRequest],
    });
  } catch (error) {
    res.status(500).json({ error: "Failed to update request" });
  }
});

// DELETE request
app.delete("/requestsAPI/:request_ID/:status_Num", async (req, res) => {
  try {
    const { request_ID } = req.params;

    const deletedRequest = await Request.findOneAndDelete({
      request_ID: request_ID,
    });

    if (!deletedRequest) {
      return res.status(404).json({ error: "Request not found" });
    }

    res.status(200).json({
      message: "Request deleted successfully",
      items: [deletedRequest],
    });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete request" });
  }
});


// =======================
// LANDHOLDER ROUTES
// =======================

// GET all landholders
app.get("/landholders", async (req, res) => {
  try {
    const data = await Landholder.find();
    res.status(200).json({ items: data });
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch landholders" });
  }
});

// POST landholder
app.post("/landholders", async (req, res) => {
  try {
    const newData = new Landholder(req.body);
    await newData.save();

    res.status(201).json({
      message: "Landholder saved",
      items: [newData],
    });
  } catch (err) {
    res.status(500).json({ error: "Failed to save landholder" });
  }
});

// DELETE landholder
app.delete("/landholders/:id", async (req, res) => {
  try {
    await Landholder.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: "Deleted" });
  } catch (err) {
    res.status(500).json({ error: "Delete failed" });
  }
});


// =======================
// SERVER START
// =======================

app.listen(5000, "0.0.0.0", () => {
  console.log("🚀 Server running on port 5000");
});