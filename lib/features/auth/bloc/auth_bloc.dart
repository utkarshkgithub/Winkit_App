import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/auth_request.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await repository.login(event.username, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final request = SignupRequest(
        username: event.username,
        email: event.email,
        password: event.password,
        passwordConfirm: event.passwordConfirm,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        address: event.address,
      );

      final user = await repository.signup(request);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (repository.isLoggedIn()) {
        final user = await repository.getCurrentUser();
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}
