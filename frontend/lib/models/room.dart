class Room {
  final String roomId;
  final String roomNumber;
  final String roomType;
  final int capacity;
  final double pricePerNight;
  final String description;
  final String? imageUrl;
  final bool available;
  final String status;

  Room({
    required this.roomId,
    required this.roomNumber,
    required this.roomType,
    required this.capacity,
    required this.pricePerNight,
    required this.description,
    this.imageUrl,
    required this.available,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
      capacity: json['capacity'] ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      available: json['available'] ?? false,
      status: json['status'] ?? 'AVAILABLE',
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
      'imageUrl': imageUrl,
      'available': available,
      'status': status,
    };
  }

  Room copyWith({
    String? roomId,
    String? roomNumber,
    String? roomType,
    int? capacity,
    double? pricePerNight,
    String? description,
    String? imageUrl,
    bool? available,
    String? status,
  }) {
    return Room(
      roomId: roomId ?? this.roomId,
      roomNumber: roomNumber ?? this.roomNumber,
      roomType: roomType ?? this.roomType,
      capacity: capacity ?? this.capacity,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      available: available ?? this.available,
      status: status ?? this.status,
    );
  }
}
