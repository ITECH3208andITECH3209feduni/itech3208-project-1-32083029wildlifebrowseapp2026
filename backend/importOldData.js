import mongoose from "mongoose";
import Request from "./models/Request.js";

// ✅ Your working MongoDB URI
const MONGO_URI = "mongodb://wildlife_user:Wildlife12345@ac-wd6zvgv-shard-00-00.xwlzzcc.mongodb.net:27017,ac-wd6zvgv-shard-00-01.xwlzzcc.mongodb.net:27017,ac-wd6zvgv-shard-00-02.xwlzzcc.mongodb.net:27017/?ssl=true&replicaSet=atlas-m90467-shard-0&authSource=admin&appName=Cluster0";

// ✅ Old AWS API
const OLD_API_URL = "https://uuy1e4eofl.execute-api.us-east-1.amazonaws.com/requestsAPI";

async function importOldData() {
  try {
    // Connect to MongoDB
    await mongoose.connect(MONGO_URI);
    console.log("✅ Connected to MongoDB");

    // Fetch old AWS data
    const response = await fetch(OLD_API_URL);

    if (!response.ok) {
      throw new Error(`❌ Old API failed: ${response.status}`);
    }

    const oldRequests = await response.json();
    console.log(`📦 Found ${oldRequests.length} old requests`);

    // OPTIONAL: clear old MongoDB data
    await Request.deleteMany({});
    console.log("🧹 Cleared existing MongoDB requests");

    // Insert old data
    await Request.insertMany(oldRequests);
    console.log("✅ Old AWS data imported successfully");

    process.exit(0);
  } catch (error) {
    console.error("❌ Import failed:", error);
    process.exit(1);
  }
}

importOldData();