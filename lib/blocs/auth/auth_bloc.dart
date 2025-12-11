import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../api/api_client.dart';
import '../../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc(this._authRepository, this._apiClient) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.login(event.email, event.password);
      final user = result['user'] as dynamic;
      final token = result['token'] as String;

      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'user_id', value: user.id);
      _apiClient.setAuthToken(token);

      emit(AuthAuthenticated(user, token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signup(
        event.name,
        event.email,
        event.password,
      );
      final user = result['user'] as dynamic;
      final token = result['token'] as String;

      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'user_id', value: user.id);
      _apiClient.setAuthToken(token);

      emit(AuthAuthenticated(user, token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_id');
    _apiClient.setAuthToken(null);
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      _apiClient.setAuthToken(token);
      // In a real app, you might want to validate the token with the server
      emit(AuthAuthenticated(User(id: '', name: '', email: ''), token));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
