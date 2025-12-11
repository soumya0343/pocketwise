import 'goal.dart';

class EvaluatedGoal {
  final String id;
  final String description;
  final GoalType type;
  final String? category;
  final double targetAmount;
  final GoalComparison comparison;
  final double actualValue;
  final bool met;

  EvaluatedGoal({
    required this.id,
    required this.description,
    required this.type,
    this.category,
    required this.targetAmount,
    required this.comparison,
    required this.actualValue,
    required this.met,
  });

  factory EvaluatedGoal.fromJson(Map<String, dynamic> json) {
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

    return EvaluatedGoal(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      type: type,
      category: json['category'],
      targetAmount: (json['targetAmount'] ?? 0).toDouble(),
      comparison: json['comparison'] == '<=' ? GoalComparison.lessThanOrEqual : GoalComparison.greaterThanOrEqual,
      actualValue: (json['actualValue'] ?? 0).toDouble(),
      met: json['met'] ?? false,
    );
  }
}

class Summary {
  final String month;
  final double totalIncome;
  final double totalExpense;
  final double savings;
  final List<EvaluatedGoal> goals;

  Summary({
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.savings,
    required this.goals,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      month: json['month'] ?? '',
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      savings: (json['savings'] ?? 0).toDouble(),
      goals: (json['goals'] as List<dynamic>?)
              ?.map((g) => EvaluatedGoal.fromJson(g))
              .toList() ??
          [],
    );
  }
}

