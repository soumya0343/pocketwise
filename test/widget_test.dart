import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketwise/api/api_client.dart';
import 'package:pocketwise/repositories/auth_repository.dart';
import 'package:pocketwise/repositories/data_repository.dart';
import 'package:pocketwise/blocs/auth/auth_bloc.dart';
import 'package:pocketwise/blocs/auth/auth_event.dart';
import 'package:pocketwise/blocs/auth/auth_state.dart';
import 'package:pocketwise/blocs/transaction/transaction_bloc.dart';
import 'package:pocketwise/blocs/goal/goal_bloc.dart';
import 'package:pocketwise/blocs/summary/summary_bloc.dart';

void main() {
  testWidgets('App starts with login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final apiClient = ApiClient();
    final authRepository = AuthRepository(apiClient);
    final dataRepository = DataRepository(apiClient);

    await tester.pumpWidget(
      MultiBlocProvider(
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
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const Scaffold(body: Text('Dashboard'));
              } else {
                return const Scaffold(body: Text('Login'));
              }
            },
          ),
        ),
      ),
    );

    // Verify that login screen is shown (when not authenticated)
    expect(find.text('Login'), findsOneWidget);
  });
}
