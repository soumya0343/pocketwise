// backend/src/models/Goal.js
const mongoose = require("mongoose");

const goalSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    month: { type: String, required: true }, // "YYYY-MM"
    type: {
      type: String,
      enum: ["CATEGORY_SPEND", "TOTAL_SPEND", "SAVINGS"],
      required: true,
    },
    category: { type: String }, // only for CATEGORY_SPEND
    comparison: { type: String, enum: ["<=", ">="], required: true },
    amount: { type: Number, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Goal", goalSchema);
