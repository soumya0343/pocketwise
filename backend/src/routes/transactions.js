// backend/src/routes/transactions.js
const router = require("express").Router();
const Transaction = require("../models/transaction");

function monthRange(monthKey) {
  const [year, month] = monthKey.split("-").map(Number);
  const start = new Date(year, month - 1, 1);
  const end = new Date(year, month, 1); // exclusive
  return { start, end };
}

// POST /api/transactions
router.post("/", async (req, res) => {
  try {
    const { date, type, category, amount, note } = req.body;
    if (!date || !type || !category || amount == null)
      return res.status(400).json({ message: "Missing fields" });

    const tx = await Transaction.create({
      userId: req.user.id,
      date: new Date(date),
      type,
      category,
      amount,
      note,
    });

    res.status(201).json(tx);
  } catch (err) {
    console.error("Create transaction error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

// GET /api/transactions?month=YYYY-MM
router.get("/", async (req, res) => {
  try {
    const { month } = req.query;
    const query = { userId: req.user.id };

    if (month) {
      const { start, end } = monthRange(month);
      query.date = { $gte: start, $lt: end };
    }

    const transactions = await Transaction.find(query).sort({ date: -1 });
    res.json(transactions);
  } catch (err) {
    console.error("Get transactions error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

// PUT /api/transactions/:id
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { date, type, category, amount, note } = req.body;
    const tx = await Transaction.findOneAndUpdate(
      { _id: id, userId: req.user.id },
      { date, type, category, amount, note },
      { new: true }
    );
    if (!tx) return res.status(404).json({ message: "Transaction not found" });
    res.json(tx);
  } catch (err) {
    console.error("Update transaction error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

// DELETE /api/transactions/:id
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Transaction.findOneAndDelete({
      _id: id,
      userId: req.user.id,
    });
    if (!result)
      return res.status(404).json({ message: "Transaction not found" });
    res.json({ message: "Deleted" });
  } catch (err) {
    console.error("Delete transaction error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
