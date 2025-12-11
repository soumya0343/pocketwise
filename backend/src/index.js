// backend/src/index.js
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db");
const authMiddleware = require("./middleware/auth");

const authRoutes = require("./routes/auth");
const transactionRoutes = require("./routes/transactions");
const goalRoutes = require("./routes/goals");
const summaryRoutes = require("./routes/summary");

const app = express();

app.use(cors());
app.use(express.json());

// Basic root route
app.get("/", (req, res) => res.send("PocketWise API running"));

app.use("/api/auth", authRoutes);
app.use("/api/transactions", authMiddleware, transactionRoutes);
app.use("/api/goals", authMiddleware, goalRoutes);
app.use("/api/summary", authMiddleware, summaryRoutes);

const PORT = process.env.PORT || 4000;

// connectDB().then(() => {
//   app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
// });

const HOST = process.env.HOST || "0.0.0.0";
connectDB().then(() => {
  const server = app.listen(PORT, HOST, () => {
    console.log(`Server listening on http://${HOST}:${PORT}`);
  });

  process.on("SIGINT", () => {
    console.log("SIGINT received — shutting down");
    server.close(() => process.exit(0));
  });
});
