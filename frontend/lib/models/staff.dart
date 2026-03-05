class Staff {
  final String staffId;
  final String? userId;
  final String fullName;
  final String email;
  final String phone;
  final String? address;
  final String? dateOfBirth;
  final String? emergencyContact;
  final String department;
  final String position;
  final double salary;
  final String status;
  final String shift;
  final String? hireDate;

  Staff({
    required this.staffId,
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.address,
    this.dateOfBirth,
    this.emergencyContact,
    required this.department,
    required this.position,
    required this.salary,
    required this.status,
    required this.shift,
    this.hireDate,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffId: json['staffId'] ?? '',
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
      emergencyContact: json['emergencyContact'],
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      salary: (json['salary'] ?? 0).toDouble(),
      status: json['status'] ?? 'ACTIVE',
      shift: json['shift'] ?? 'MORNING',
      hireDate: json['hireDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'emergencyContact': emergencyContact,
      'department': department,
      'position': position,
      'salary': salary,
      'status': status,
      'shift': shift,
      'hireDate': hireDate,
    };
  }

  Staff copyWith({
    String? staffId,
    String? userId,
    String? fullName,
    String? email,
    String? phone,
    String? department,
    String? position,
    double? salary,
    String? status,
    String? shift,
    String? hireDate,
  }) {
    return Staff(
      staffId: staffId ?? this.staffId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      department: department ?? this.department,
      position: position ?? this.position,
      salary: salary ?? this.salary,
      status: status ?? this.status,
      shift: shift ?? this.shift,
      hireDate: hireDate ?? this.hireDate,
    );
  }
}
