/// Parses an ISO-8601 datetime string robustly.
/// Handles the legacy backend bug that produced duplicate fractional-second
/// segments like "2026-03-18T14:00:00.000.000.0".
DateTime _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();

  // Remove duplicate fractional-second groups: keep only the first ".digits"
  // after the seconds field. E.g. "14:00:00.000.000.0" → "14:00:00.000"
  final cleaned = raw.replaceAllMapped(
    RegExp(r'(\d{2}:\d{2}:\d{2})(\.\d+)(\.\d+)+'),
    (m) => '${m[1]}${m[2]}',
  );

  return DateTime.parse(cleaned);
}

class Reservation {
  final String reservationId;
  final String reservationNumber;
  final String guestId;
  final String guestName;
  final String roomId;
  final String roomNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final DateTime? actualCheckIn;
  final DateTime? actualCheckOut;
  final int numberOfNights;
  final double totalCost;
  final String status;
  final String? specialRequests;
  final String roomType;
  final String? paymentMethod;
  final String? paymentStatus;

  Reservation({
    required this.reservationId,
    required this.reservationNumber,
    required this.guestId,
    required this.guestName,
    required this.roomId,
    required this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
    this.actualCheckIn,
    this.actualCheckOut,
    required this.numberOfNights,
    required this.totalCost,
    required this.status,
    this.specialRequests,
    required this.roomType,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['reservationId'] ?? '',
      reservationNumber: json['reservationNumber'] ?? '',
      guestId: json['guest']?['guestId'] ?? '',
      guestName: json['guest']?['name'] ?? '',
      roomId: json['room']?['roomId'] ?? '',
      roomNumber: json['room']?['roomNumber'] ?? '',
      checkInDate: _parseDate(json['checkInDate']),
      checkOutDate: _parseDate(json['checkOutDate']),
      actualCheckIn: json['actualCheckIn'] != null
          ? _parseDate(json['actualCheckIn'])
          : null,
      actualCheckOut: json['actualCheckOut'] != null
          ? _parseDate(json['actualCheckOut'])
          : null,
      numberOfNights: json['numberOfNights'] ?? 0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'PENDING',
      specialRequests: json['specialRequests'],
      roomType: json['room']?['roomType'] ?? '',
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservationId': reservationId,
      'reservationNumber': reservationNumber,
      'guestId': guestId,
      'guestName': guestName,
      'roomId': roomId,
      'roomNumber': roomNumber,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'actualCheckIn': actualCheckIn?.toIso8601String(),
      'actualCheckOut': actualCheckOut?.toIso8601String(),
      'numberOfNights': numberOfNights,
      'totalCost': totalCost,
      'status': status,
      'specialRequests': specialRequests,
      'roomType': roomType,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }
}

class Bill {
  final String reservationNumber;
  final String guestName;
  final String roomNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfNights;
  final double pricePerNight;
  final double totalCost;
  final DateTime generatedAt;

  Bill({
    required this.reservationNumber,
    required this.guestName,
    required this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfNights,
    required this.pricePerNight,
    required this.totalCost,
    required this.generatedAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      reservationNumber: json['reservationNumber'] ?? '',
      guestName: json['guestName'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      checkInDate: _parseDate(json['checkInDate']),
      checkOutDate: _parseDate(json['checkOutDate']),
      numberOfNights: json['numberOfNights'] ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      generatedAt: _parseDate(json['generatedAt']),
    );
  }
}
