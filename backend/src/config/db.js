// backend/src/config/db.js (verbose)
const mongoose = require("mongoose");

async function connectDB() {
  const uri = process.env.MONGO_URI;
  if (!uri) {
    console.error("connectDB: MONGO_URI not set in environment");
    return Promise.reject(new Error("MONGO_URI not set"));
  }

  console.log(
    "connectDB: Attempting mongoose.connect to",
    uri.startsWith("mongodb://") ? "(mongodb uri set)" : uri
  );

  try {
    // Increase serverSelectionTimeoutMS so errors surface quickly (5s)
    await mongoose.connect(uri, {
      // useNewUrlParser: true, // modern mongoose doesn't need this option
      // useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });

    console.log("connectDB: MongoDB connected ✅");
  } catch (err) {
    console.error("connectDB: MongoDB connection error — full error below:");
    console.error(err);
    // rethrow so caller knows connection failed
    throw err;
  }
}

module.exports = connectDB;
