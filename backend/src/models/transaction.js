// backend/src/models/Transaction.js
const mongoose = require("mongoose");

const transactionSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    date: { type: Date, required: true },
    type: { type: String, enum: ["INCOME", "EXPENSE"], required: true },
    category: { type: String, required: true },
    amount: { type: Number, required: true },
    note: { type: String },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Transaction", transactionSchema);
