import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/room.dart';
import '../models/reservation.dart';

class ApiService {
  // Adjust this based on where your backend runs.
  // For desktop/web on same machine:
  static const String baseUrl = 'http://localhost:8080/api';

  // For Android emulator: use 'http://10.0.2.2:8080/api'
  // For real device: use your LAN IP, e.g. 'http://192.168.x.x:8080/api'

  static Future<User> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<Room>> getAllRooms() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/rooms'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Room.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<Room>> getAvailableRooms() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/rooms?available=true'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Room.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load available rooms');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Reservation> createReservation({
    required String guestId,
    required String roomId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    String? specialRequests,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reservations'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'guest': {'guestId': guestId},
              'room': {'roomId': roomId},
              'checkInDate': checkInDate.toString().split(' ')[0],
              'checkOutDate': checkOutDate.toString().split(' ')[0],
              'specialRequests': specialRequests,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Reservation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create reservation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Reservation> getReservation(String reservationId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reservations/$reservationId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Reservation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Reservation not found');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Reservation> getReservationByNumber(
    String reservationNumber,
  ) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reservations/number/$reservationNumber'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Reservation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Reservation not found');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<Reservation>> getGuestReservations(String guestId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reservations/guest/$guestId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Reservation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Bill> getBill(String reservationId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reservations/$reservationId/bill'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Bill.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to generate bill');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> cancelReservation(String reservationId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/reservations/$reservationId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel reservation');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<User> register(
    String username,
    String password,
    String email,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
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
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/users'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => User.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<User>> getUsersByRole(String role) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/users/role/$role'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => User.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load users by role');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<Reservation>> getAllReservations() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reservations'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Reservation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load all reservations');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Admin User Management
  static Future<void> deleteUser(String userId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/users/$userId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> updateUser(User user) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/users'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(user.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<User> adminCreateUser({
    required String username,
    required String password,
    required String email,
    required List<String> roles,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/admin/users'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'email': email,
              'roles': roles,
              'enabled': true,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Admin Room Management
  static Future<Room> createRoom(Room room) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/rooms'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(room.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Room.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create room');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Room> updateRoom(Room room) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/rooms'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(room.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Room.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update room');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> deleteRoom(String roomId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/rooms/$roomId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete room');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> updateReservationStatus(
      String reservationId, String status) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/reservations/$reservationId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'status': status}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update reservation status');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
