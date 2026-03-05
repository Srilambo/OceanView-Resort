import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';
import '../../../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  UserRole get userRole => _currentUser?.userRole ?? UserRole.GUEST;

  Future<void> register(String username, String password, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .post(
            Uri.parse('${ApiService.baseUrl}/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'email': email,
              'enabled': true,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        _currentUser = UserModel.fromJson(userData);
        _error = null;
      } else {
        String msg = 'Registration failed';
        try {
          final errorData = jsonDecode(response.body);
          msg = errorData['error'] ?? msg;
        } catch (_) {}
        _error = msg;
        _currentUser = null;
      }
    } catch (e) {
      _error = "Connection error: $e";
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Call the real backend API
      final response = await http
          .post(
            Uri.parse('${ApiService.baseUrl}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        _currentUser = UserModel.fromJson(userData);
        _error = null;
      } else {
        // Clearer error from backend
        String msg = 'Login failed';
        try {
          final errorData = jsonDecode(response.body);
          msg = errorData['error'] ?? msg;
        } catch (_) {}

        _error = msg;
        _currentUser = null;
      }
    } catch (e) {
      _error = "Connection error: $e";
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
        return role == UserRole.ADMIN || role == UserRole.STAFF;
      case 'PERM_MANAGE_PRICING':
        return role == UserRole.ADMIN;
      default:
        return false;
    }
  }
}
