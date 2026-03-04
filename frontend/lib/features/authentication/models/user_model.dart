import 'user_role.dart';

class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String role; // Stores the raw role string from API
  final bool enabled;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    this.enabled = true,
  });

  // Helper getter to get UserRole enum
  UserRole get userRole {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.ADMIN;
      case 'MANAGER':
        return UserRole.MANAGER;
      case 'STAFF':
        return UserRole.STAFF;
      case 'GUEST':
      default:
        return UserRole.GUEST;
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['user_id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'GUEST',
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'role': role,
      'enabled': enabled,
    };
  }
}
