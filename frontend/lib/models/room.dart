class Room {
  final String roomId;
  final String roomNumber;
  final String roomType;
  final int capacity;
  final double pricePerNight;
  final String description;
  final bool available;

  Room({
    required this.roomId,
    required this.roomNumber,
    required this.roomType,
    required this.capacity,
    required this.pricePerNight,
    required this.description,
    required this.available,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
      capacity: json['capacity'] ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      available: json['available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomNumber': roomNumber,
      'roomType': roomType,
      'capacity': capacity,
      'pricePerNight': pricePerNight,
      'description': description,
      'available': available,
    };
  }
}
