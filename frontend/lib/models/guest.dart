class Guest {
  final String guestId;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String idType;
  final String idNumber;
  final String nationality;

  Guest({
    required this.guestId,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.idType,
    required this.idNumber,
    required this.nationality,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      guestId: json['guestId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      address: json['address'] ?? '',
      idType: json['idType'] ?? '',
      idNumber: json['idNumber'] ?? '',
      nationality: json['nationality'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guestId': guestId,
      'name': name,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'idType': idType,
      'idNumber': idNumber,
      'nationality': nationality,
    };
  }
}
