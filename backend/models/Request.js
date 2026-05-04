import mongoose from "mongoose";

const requestSchema = new mongoose.Schema({
  title: String,
  description: String,
  location: String,
  status: {
    type: String,
    default: "pending"
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Request = mongoose.model("Request", requestSchema);

export default Request;