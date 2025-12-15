import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class AuthSignupRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String passwordConfirm;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;

  const AuthSignupRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    passwordConfirm,
    firstName,
    lastName,
    phoneNumber,
    address,
  ];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
