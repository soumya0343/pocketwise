import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api/api_client.dart';
import 'repositories/auth_repository.dart';
import 'repositories/data_repository.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/transaction/transaction_bloc.dart';
import 'blocs/goal/goal_bloc.dart';
import 'blocs/summary/summary_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const PocketWiseApp());
}

class PocketWiseApp extends StatelessWidget {
  const PocketWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final authRepository = AuthRepository(apiClient);
    final dataRepository = DataRepository(apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthBloc(authRepository, apiClient)
                ..add(const AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => TransactionBloc(dataRepository)),
        BlocProvider(create: (_) => GoalBloc(dataRepository)),
        BlocProvider(create: (_) => SummaryBloc(dataRepository)),
      ],
      child: MaterialApp(
        title: 'PocketWise',
        theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const DashboardScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/dashboard': (_) => const DashboardScreen(),
        },
      ),
    );
  }
}
