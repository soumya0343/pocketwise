enum GoalType { categorySpend, totalSpend, savings }

enum GoalComparison { lessThanOrEqual, greaterThanOrEqual }

class Goal {
  final String id;
  final String month; // "YYYY-MM"
  final GoalType type;
  final String? category; // only for CATEGORY_SPEND
  final GoalComparison comparison;
  final double amount;

  Goal({
    required this.id,
    required this.month,
    required this.type,
    this.category,
    required this.comparison,
    required this.amount,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    GoalType type;
    switch (json['type']) {
      case 'CATEGORY_SPEND':
        type = GoalType.categorySpend;
        break;
      case 'TOTAL_SPEND':
        type = GoalType.totalSpend;
        break;
      case 'SAVINGS':
        type = GoalType.savings;
        break;
      default:
        type = GoalType.totalSpend;
    }

    return Goal(
      id: json['_id'] ?? json['id'] ?? '',
      month: json['month'] ?? '',
      type: type,
      category: json['category'],
      comparison: json['comparison'] == '<=' ? GoalComparison.lessThanOrEqual : GoalComparison.greaterThanOrEqual,
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    String typeStr;
    switch (type) {
      case GoalType.categorySpend:
        typeStr = 'CATEGORY_SPEND';
        break;
      case GoalType.totalSpend:
        typeStr = 'TOTAL_SPEND';
        break;
      case GoalType.savings:
        typeStr = 'SAVINGS';
        break;
    }

    return {
      'month': month,
      'type': typeStr,
      if (category != null) 'category': category,
      'comparison': comparison == GoalComparison.lessThanOrEqual ? '<=' : '>=',
      'amount': amount,
    };
  }
}

