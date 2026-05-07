import mongoose from "mongoose";

const requestSchema = new mongoose.Schema({}, { strict: false });

const Request = mongoose.model("Request", requestSchema);

export default Request;