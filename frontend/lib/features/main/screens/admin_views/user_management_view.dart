import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/user.dart';
import '../../../../services/api_service.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  late Future<List<User>> _usersFuture;
  int _selectedTab = 0; // 0: Guests, 1: Staff & Admins

  @override
  void initState() {
    super.initState();
    _usersFuture = ApiService.getAllUsers();
  }

  void _refresh() {
    setState(() {
      _usersFuture = ApiService.getAllUsers();
    });
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await ApiService.deleteUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  void _showAddUserDialog() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'ROLE_STAFF';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Staff/Admin', style: GoogleFonts.playfairDisplay()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedRole,
              items: const [
                DropdownMenuItem(value: 'ROLE_ADMIN', child: Text('Admin')),
                DropdownMenuItem(value: 'ROLE_STAFF', child: Text('Staff')),
              ],
              onChanged: (val) => selectedRole = val!,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ApiService.adminCreateUser(
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  roles: [selectedRole],
                );
                Navigator.pop(context);
                _refresh();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Accounts Management',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddUserDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Staff/Admin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tab Switcher
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildTab(0, 'Guests'),
                _buildTab(1, 'Staff & Admins'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 8),
                ],
              ),
              child: FutureBuilder<List<User>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade300, size: 48),
                          const SizedBox(height: 16),
                          Text('Error loading users',
                              style: GoogleFonts.montserrat(color: Colors.red)),
                          TextButton(
                              onPressed: _refresh, child: const Text('Retry')),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No users found.',
                          style: GoogleFonts.montserrat(color: Colors.grey)),
                    );
                  }

                  String targetDisplay = _selectedTab == 0 ? 'Guest' : 'Staff';
                  bool includeAdmins = _selectedTab == 1;

                  final userList = snapshot.data!
                      .where((u) =>
                          u.displayRole == targetDisplay ||
                          (includeAdmins && u.displayRole == 'Admin'))
                      .toList();

                  if (userList.isEmpty) {
                    return Center(
                      child: Text(
                          _selectedTab == 0
                              ? 'No Guest accounts found.'
                              : 'No Staff or Admin accounts found.',
                          style: GoogleFonts.montserrat(color: Colors.grey)),
                    );
                  }

                  return ListView.separated(
                    itemCount: userList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF1565C0).withOpacity(0.1),
                          child: Text(
                            user.username.isNotEmpty
                                ? user.username[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          user.username,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D47A1)),
                        ),
                        subtitle: Text(
                          user.email,
                          style: GoogleFonts.montserrat(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: user.authenticated
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.authenticated ? 'Active' : 'Inactive',
                                style: GoogleFonts.montserrat(
                                  color: user.authenticated
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 100, // Increased width
                              child: Text(
                                user.displayRole,
                                style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue, size: 20),
                                onPressed: () {
                                  // Implementation for edit could go here
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                onPressed: () => _deleteUser(user.userId)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                : null,
          ),
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
