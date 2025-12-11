// backend/src/routes/summary.js
const router = require("express").Router();
const Goal = require("../models/goal");
const Transaction = require("../models/transaction");

function monthRange(monthKey) {
  const [year, month] = monthKey.split("-").map(Number);
  const start = new Date(year, month - 1, 1);
  const end = new Date(year, month, 1);
  return { start, end };
}

function buildGoalDescription(goal) {
  if (goal.type === "CATEGORY_SPEND") {
    return `${goal.category} spend ${goal.comparison} ${goal.amount}`;
  }
  if (goal.type === "TOTAL_SPEND") {
    return `Total spend ${goal.comparison} ${goal.amount}`;
  }
  if (goal.type === "SAVINGS") {
    return `Savings ${goal.comparison} ${goal.amount}`;
  }
  return "Goal";
}

router.get("/", async (req, res) => {
  try {
    const { month } = req.query;
    if (!month) return res.status(400).json({ message: "month is required" });

    const { start, end } = monthRange(month);
    const userId = req.user.id;

    const [transactions, goals] = await Promise.all([
      Transaction.find({ userId, date: { $gte: start, $lt: end } }),
      Goal.find({ userId, month }),
    ]);

    const totalIncome = transactions
      .filter((t) => t.type === "INCOME")
      .reduce((s, t) => s + t.amount, 0);
    const totalExpense = transactions
      .filter((t) => t.type === "EXPENSE")
      .reduce((s, t) => s + t.amount, 0);
    const savings = totalIncome - totalExpense;

    const evaluatedGoals = goals.map((goal) => {
      let value = 0;

      if (goal.type === "CATEGORY_SPEND") {
        value = transactions
          .filter((t) => t.type === "EXPENSE" && t.category === goal.category)
          .reduce((s, t) => s + t.amount, 0);
      } else if (goal.type === "TOTAL_SPEND") {
        value = totalExpense;
      } else if (goal.type === "SAVINGS") {
        value = savings;
      }

      const met =
        goal.comparison === "<=" ? value <= goal.amount : value >= goal.amount;

      return {
        id: goal._id,
        description: buildGoalDescription(goal),
        type: goal.type,
        category: goal.category,
        targetAmount: goal.amount,
        comparison: goal.comparison,
        actualValue: Number(value.toFixed(2)),
        met,
      };
    });

    res.json({
      month,
      totalIncome,
      totalExpense,
      savings,
      goals: evaluatedGoals,
    });
  } catch (err) {
    console.error("Summary error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
