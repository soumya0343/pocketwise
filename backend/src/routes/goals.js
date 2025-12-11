// backend/src/routes/goals.js
const router = require("express").Router();
const Goal = require("../models/goal");

// POST /api/goals
router.post("/", async (req, res) => {
  try {
    const { month, type, category, comparison, amount } = req.body;
    if (!month || !type || !comparison || amount == null)
      return res.status(400).json({ message: "Missing fields" });

    const goal = await Goal.create({
      userId: req.user.id,
      month,
      type,
      category,
      comparison,
      amount,
    });

    res.status(201).json(goal);
  } catch (err) {
    console.error("Create goal error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

// GET /api/goals?month=YYYY-MM
router.get("/", async (req, res) => {
  try {
    const { month } = req.query;
    const query = { userId: req.user.id };
    if (month) query.month = month;

    const goals = await Goal.find(query).sort({ createdAt: -1 });
    res.json(goals);
  } catch (err) {
    console.error("Get goals error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

// DELETE /api/goals/:id
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Goal.findOneAndDelete({
      _id: id,
      userId: req.user.id,
    });
    if (!result) return res.status(404).json({ message: "Goal not found" });
    res.json({ message: "Deleted" });
  } catch (err) {
    console.error("Delete goal error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
