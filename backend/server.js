import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import Request from "./models/Request.js";

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// 🔴 Put your correct password here
const MONGO_URI = "mongodb://wildlife_user:Wildlife12345@ac-wd6zvgv-shard-00-00.xwlzzcc.mongodb.net:27017,ac-wd6zvgv-shard-00-01.xwlzzcc.mongodb.net:27017,ac-wd6zvgv-shard-00-02.xwlzzcc.mongodb.net:27017/?ssl=true&replicaSet=atlas-m90467-shard-0&authSource=admin&appName=Cluster0";

// Connect to MongoDB
mongoose.connect(MONGO_URI)
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.log("❌ Error:", err));

// Test route
app.get("/", (req, res) => {
  res.send("Backend is running 🚀");
});

// 🔥 GET all requests
app.get("/requests", async (req, res) => {
  const requests = await Request.find();
  res.json(requests);
});

// 🔥 POST new request
app.post("/requests", async (req, res) => {
  const newRequest = new Request(req.body);
  await newRequest.save();
  res.json(newRequest);
});

// 🔥 DELETE request
app.delete("/requests/:id", async (req, res) => {
  await Request.findByIdAndDelete(req.params.id);
  res.json({ message: "Deleted successfully" });
});

// Start server
app.listen(5000, () => {
  console.log("🚀 Server running on port 5000");
});