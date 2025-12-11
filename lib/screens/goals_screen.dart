import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/goal/goal_bloc.dart';
import '../blocs/goal/goal_event.dart';
import '../blocs/goal/goal_state.dart';
import '../models/goal.dart';
import '../widgets/goal_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _currentMonth = _getCurrentMonth();

  static String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    context.read<GoalBloc>().add(GoalLoadRequested(month: _currentMonth));
  }

  void _showAddGoalDialog() {
    final formKey = GlobalKey<FormState>();
    GoalType selectedType = GoalType.totalSpend;
    String? selectedCategory;
    GoalComparison selectedComparison = GoalComparison.lessThanOrEqual;
    final amountController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Goal'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<GoalType>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: 'Goal Type'),
                    items: const [
                      DropdownMenuItem(value: GoalType.categorySpend, child: Text('Category Spend')),
                      DropdownMenuItem(value: GoalType.totalSpend, child: Text('Total Spend')),
                      DropdownMenuItem(value: GoalType.savings, child: Text('Savings')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                  if (selectedType == GoalType.categorySpend) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                      onSaved: (value) => selectedCategory = value,
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<GoalComparison>(
                    value: selectedComparison,
                    decoration: const InputDecoration(labelText: 'Comparison'),
                    items: const [
                      DropdownMenuItem(value: GoalComparison.lessThanOrEqual, child: Text('<=')),
                      DropdownMenuItem(value: GoalComparison.greaterThanOrEqual, child: Text('>=')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedComparison = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final goal = Goal(
                    id: '',
                    month: _currentMonth,
                    type: selectedType,
                    category: selectedCategory,
                    comparison: selectedComparison,
                    amount: double.parse(amountController.text),
                  );
                  context.read<GoalBloc>().add(GoalCreateRequested(goal));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GoalLoaded) {
            if (state.goals.isEmpty) {
              return const Center(child: Text('No goals set for this month'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.goals.length,
              itemBuilder: (context, index) {
                return GoalCard(
                  goal: state.goals[index],
                  onDelete: () {
                    context.read<GoalBloc>().add(GoalDeleteRequested(state.goals[index].id));
                  },
                );
              },
            );
          } else if (state is GoalError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No goals'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

