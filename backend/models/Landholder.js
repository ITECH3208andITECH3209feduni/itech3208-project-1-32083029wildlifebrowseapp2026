import mongoose from "mongoose";

const landholderSchema = new mongoose.Schema({}, { strict: false });

const Landholder = mongoose.model("Landholder", landholderSchema);

export default Landholder;