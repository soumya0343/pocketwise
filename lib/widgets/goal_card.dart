import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onDelete,
  });

  String _getGoalTypeString() {
    switch (goal.type) {
      case GoalType.categorySpend:
        return 'Category Spend: ${goal.category}';
      case GoalType.totalSpend:
        return 'Total Spend';
      case GoalType.savings:
        return 'Savings';
    }
  }

  String _getComparisonString() {
    return goal.comparison == GoalComparison.lessThanOrEqual ? '<=' : '>=';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(_getGoalTypeString()),
        subtitle: Text(
          '${_getComparisonString()} \$${goal.amount.toStringAsFixed(2)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

