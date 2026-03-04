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
    // Handle roles list from backend
    String extractedRole = 'GUEST';
    if (json['roles'] != null) {
      if (json['roles'] is List) {
        List<dynamic> rolesList = json['roles'];
        if (rolesList.contains('ADMIN') || rolesList.contains('ROLE_ADMIN')) {
          extractedRole = 'ADMIN';
        } else if (rolesList.contains('MANAGER') ||
            rolesList.contains('ROLE_MANAGER')) {
          extractedRole = 'MANAGER';
        } else if (rolesList.contains('STAFF') ||
            rolesList.contains('ROLE_STAFF')) {
          extractedRole = 'STAFF';
        } else if (rolesList.isNotEmpty) {
          extractedRole = rolesList[0].toString();
        }
      } else if (json['roles'] is String) {
        extractedRole = json['roles'];
      }
    } else if (json['role'] != null) {
      extractedRole = json['role'];
    }

    return UserModel(
      id: json['userId'] ?? json['user_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      fullName:
          json['fullName'] ?? json['full_name'] ?? json['username'] ?? 'User',
      email: json['email'] ?? '',
      role: extractedRole,
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
