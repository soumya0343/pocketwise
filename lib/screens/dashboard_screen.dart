import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/summary/summary_bloc.dart';
import '../blocs/summary/summary_event.dart';
import '../blocs/summary/summary_state.dart';
import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';
import 'add_transaction_screen.dart';
import 'goals_screen.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String _currentMonth = _getCurrentMonth();

  static String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    context.read<SummaryBloc>().add(SummaryLoadRequested(_currentMonth));
    context.read<TransactionBloc>().add(
      TransactionLoadRequested(month: _currentMonth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Section
          BlocBuilder<SummaryBloc, SummaryState>(
            builder: (context, state) {
              if (state is SummaryLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              } else if (state is SummaryLoaded) {
                final summary = state.summary;
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Month: ${summary.month}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Income: \$${summary.totalIncome.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Expenses: \$${summary.totalExpense.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Savings: \$${summary.savings.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: summary.savings >= 0
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is SummaryError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${state.message}'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Transactions Section
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  if (state.transactions.isEmpty) {
                    return const Center(child: Text('No transactions yet'));
                  }
                  return ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: state.transactions[index],
                      );
                    },
                  );
                } else if (state is TransactionError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('No transactions'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
          if (mounted) {
            context.read<TransactionBloc>().add(
              TransactionLoadRequested(month: _currentMonth),
            );
            context.read<SummaryBloc>().add(
              SummaryLoadRequested(_currentMonth),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GoalsScreen()));
          }
        },
      ),
    );
  }
}
