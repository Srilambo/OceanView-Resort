class Reservation {
  final String reservationId;
  final String reservationNumber;
  final String guestId;
  final String guestName;
  final String roomId;
  final String roomNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfNights;
  final double totalCost;
  final String status;
  final String? specialRequests;

  Reservation({
    required this.reservationId,
    required this.reservationNumber,
    required this.guestId,
    required this.guestName,
    required this.roomId,
    required this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfNights,
    required this.totalCost,
    required this.status,
    this.specialRequests,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['reservationId'] ?? '',
      reservationNumber: json['reservationNumber'] ?? '',
      guestId: json['guest']?['guestId'] ?? '',
      guestName: json['guest']?['name'] ?? '',
      roomId: json['room']?['roomId'] ?? '',
      roomNumber: json['room']?['roomNumber'] ?? '',
      checkInDate: DateTime.parse(
        json['checkInDate'] ?? DateTime.now().toString(),
      ),
      checkOutDate: DateTime.parse(
        json['checkOutDate'] ?? DateTime.now().toString(),
      ),
      numberOfNights: json['numberOfNights'] ?? 0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'PENDING',
      specialRequests: json['specialRequests'],
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
      'checkInDate': checkInDate.toString().split(' ')[0],
      'checkOutDate': checkOutDate.toString().split(' ')[0],
      'numberOfNights': numberOfNights,
      'totalCost': totalCost,
      'status': status,
      'specialRequests': specialRequests,
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
      checkInDate: DateTime.parse(json['checkInDate'] ?? ''),
      checkOutDate: DateTime.parse(json['checkOutDate'] ?? ''),
      numberOfNights: json['numberOfNights'] ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      generatedAt: DateTime.parse(
        json['generatedAt'] ?? DateTime.now().toString(),
      ),
    );
  }
}
