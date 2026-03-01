class Guest {
  final String guestId;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String passportNumber;

  Guest({
    required this.guestId,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.passportNumber,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      guestId: json['guestId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      address: json['address'] ?? '',
      passportNumber: json['passportNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guestId': guestId,
      'name': name,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'passportNumber': passportNumber,
    };
  }
}
