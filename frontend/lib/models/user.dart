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
      userId: json['userId'] ?? json['user_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      authenticated: json['authenticated'] ?? true,
    );
  }

  // Get user-friendly role name
  String get displayRole {
    if (roles.contains('ROLE_ADMIN') ||
        roles.contains('ADMIN') ||
        roles.contains('ROLE_MANAGER') ||
        roles.contains('MANAGER')) {
      return 'Admin';
    }
    if (roles.contains('ROLE_STAFF') || roles.contains('STAFF')) {
      return 'Staff';
    }
    return 'Guest';
  }

  // Check if user has a specific role
  bool hasRole(String roleName) {
    return roles.contains(roleName) || roles.contains('ROLE_$roleName');
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
