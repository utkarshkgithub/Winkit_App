import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? address;
  final DateTime dateJoined;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.address,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      phoneNumber: json['phone_number']?.toString().isEmpty ?? true
          ? null
          : json['phone_number'].toString(),
      address: json['address']?.toString().isEmpty ?? true
          ? null
          : json['address'].toString(),
      dateJoined: DateTime.parse(json['date_joined'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'address': address,
      'date_joined': dateJoined.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    phoneNumber,
    address,
    dateJoined,
  ];
}
