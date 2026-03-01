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
}
