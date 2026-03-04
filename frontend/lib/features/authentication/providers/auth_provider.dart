import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  UserRole get userRole => _currentUser?.userRole ?? UserRole.GUEST;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Temporary mock login for development
      // In real scenario, this would call services/auth_service.dart
      await Future.delayed(const Duration(seconds: 1));

      if (username == 'admin' && password == 'admin123') {
        _currentUser = UserModel(
          id: 'admin_1',
          username: 'admin',
          fullName: 'System Administrator',
          email: 'admin@oceanview.com',
          role: 'ADMIN',
        );
      } else if (username == 'manager' && password == 'manager123') {
        _currentUser = UserModel(
          id: 'mgr_1',
          username: 'manager_one',
          fullName: 'Hotel Manager',
          email: 'manager@oceanview.com',
          role: 'MANAGER',
        );
      } else if (username == 'staff' && password == 'staff123') {
        _currentUser = UserModel(
          id: 'staff_1',
          username: 'staff_one',
          fullName: 'Front Desk Staff',
          email: 'staff@oceanview.com',
          role: 'STAFF',
        );
      } else {
        // Default as GUEST for others
        _currentUser = UserModel(
          id: 'guest_1',
          username: username,
          fullName: 'Guest User',
          email: '$username@example.com',
          role: 'GUEST',
        );
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  bool hasPermission(String permission) {
    if (_currentUser == null) return false;

    final role = userRole;
    if (role == UserRole.ADMIN) return true; // Admin has all permissions

    // Simple permission logic based on role
    switch (permission) {
      case 'PERM_VIEW_ROOMS':
        return true; // All roles can view rooms
      case 'PERM_CREATE_ROOM':
        return role == UserRole.ADMIN;
      case 'PERM_VIEW_RESERVATIONS':
        return role != UserRole.GUEST;
      case 'PERM_MANAGE_USERS':
        return role == UserRole.ADMIN;
      case 'PERM_VIEW_REPORTS':
        return role == UserRole.ADMIN ||
            role == UserRole.MANAGER ||
            role == UserRole.STAFF;
      case 'PERM_MANAGE_PRICING':
        return role == UserRole.ADMIN || role == UserRole.MANAGER;
      default:
        return false;
    }
  }
}
