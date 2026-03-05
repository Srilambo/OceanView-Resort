class Guest {
  final String guestId;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String idType;
  final String idNumber;
  final String nationality;
  final String userId;

  Guest({
    required this.guestId,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.idType,
    required this.idNumber,
    required this.nationality,
    required this.userId,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      guestId: json['guestId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      address: json['address'] ?? '',
      idType: json['idType'] ?? '',
      idNumber: json['idNumber'] ?? json['id_number'] ?? '',
      nationality: json['nationality'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
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
      'userId': userId,
    };
  }
}
