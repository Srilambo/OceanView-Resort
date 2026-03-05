import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/room.dart';
import '../models/reservation.dart';
import '../models/staff.dart';
import '../models/task.dart';
import '../models/resort_service.dart';
import '../models/review.dart';
import '../models/guest.dart';

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
        throw Exception(
            'Server returned ${response.statusCode}: ${response.body}');
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
              'checkInDate': checkInDate.toIso8601String(),
              'checkOutDate': checkOutDate.toIso8601String(),
              'specialRequests': specialRequests,
              'paymentMethod': 'CASH',
              'paymentStatus': 'PENDING_STAFF_CHECK',
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
        throw Exception(
            'Server returned ${response.statusCode}: ${response.body}');
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
    String reservationId,
    String status,
  ) async {
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

  // ========== Staff Management ==========

  static Future<List<Staff>> getAllStaff() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/staff'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Staff.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load staff');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Staff> createStaff(Staff staff) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/staff'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(staff.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Staff.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to create staff');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Staff> updateStaff(Staff staff) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/staff'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(staff.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Staff.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update staff');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> deleteStaff(String staffId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/staff/$staffId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete staff');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Map<String, dynamic>> getStaffStats() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/staff/stats'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load staff stats');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<Staff>> getStaffByDepartment(String department) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/staff/department/$department'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Staff.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load staff by department');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // ========== Task Management ==========

  static Future<List<StaffTask>> getAllTasks() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/tasks'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => StaffTask.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<StaffTask>> getStaffTasks(String staffId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/tasks/staff/$staffId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => StaffTask.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load staff tasks');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<StaffTask> createTask(StaffTask task) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return StaffTask.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<StaffTask> updateTask(StaffTask task) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return StaffTask.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      final response = await http
          .patch(Uri.parse('$baseUrl/tasks/$taskId/status/$status'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update task status');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> deleteTask(String taskId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/tasks/$taskId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // ========== Resort Services ==========

  static Future<List<ResortService>> getAllServices() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/services'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => ResortService.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load resort services');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<List<ResortService>> getServicesByCategory(
      String category) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/services/category/$category'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => ResortService.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load resort services by category');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // ========== Reviews ==========

  static Future<List<Review>> getAllReviews() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reviews'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Review.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Review> createReview(Review review) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reviews'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(review.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Review.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create review');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> checkIn(String reservationId) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/reservations/$reservationId/check-in'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to check in');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> checkOut(String reservationId) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/reservations/$reservationId/check-out'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to check out');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // ========== Guest Management ==========

  static Future<Guest> getGuestByUserId(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/guests/user/$userId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Guest.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Guest not found');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Guest> updateGuest(Guest guest) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/guests'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(guest.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Guest.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update guest profile');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // ========== Service Billing ==========

  static Future<void> addServiceToReservation({
    required String reservationId,
    required String serviceId,
    required String serviceName,
    required double servicePrice,
    int quantity = 1,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reservations/$reservationId/services'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'serviceId': serviceId,
              'serviceName': serviceName,
              'servicePrice': servicePrice,
              'quantity': quantity,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        final err = jsonDecode(response.body);
        throw Exception(err['error'] ?? 'Failed to add service to bill');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Map<String, dynamic>> getBillDetails(
      String reservationId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reservations/$reservationId/bill'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get bill');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Map<String, dynamic>> checkOutWithPayment({
    required String reservationId,
    required String paymentMethod,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reservations/$reservationId/checkout-pay'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'paymentMethod': paymentMethod}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final err = jsonDecode(response.body);
        throw Exception(err['error'] ?? 'Failed to checkout');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
