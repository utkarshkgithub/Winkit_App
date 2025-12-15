import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  @override
  List<Object?> get props => [username, password];
}

class SignupRequest extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordConfirm;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;

  const SignupRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'password_confirm': passwordConfirm,
      'first_name': firstName ?? '',
      'last_name': lastName ?? '',
      'phone_number': phoneNumber ?? '',
      'address': address ?? '',
    };
  }

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
