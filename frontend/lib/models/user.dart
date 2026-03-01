class User {
  final String userId;
  final String username;
  final String email;
  final List<String> roles;
  final bool authenticated;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.roles,
    this.authenticated = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      authenticated: json['authenticated'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'roles': roles,
      'authenticated': authenticated,
    };
  }
}
