import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../../../services/api_service.dart';
import '../../../../models/guest.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  Guest? _guest;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchGuestData();
  }

  Future<void> _fetchGuestData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      setState(() {
        _isLoading = false;
        _error = "User not logged in";
      });
      return;
    }

    try {
      final guest = await ApiService.getGuestByUserId(userId);
      setState(() {
        _guest = guest;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Failed to load profile',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: GoogleFonts.montserrat(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchGuestData();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final String fullName = _guest?.name ?? 'Guest User';
    final String email = _guest?.email ?? 'N/A';
    final String initial =
        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'G';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your personal information and preferences',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1565C0),
                  child: Text(
                    initial,
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fullName,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D47A1),
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (_guest?.guestId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Guest ID: ${_guest!.guestId}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildProfileSection(
            title: 'Personal Information',
            children: [
              _buildProfileItem(
                  icon: Icons.person, title: 'Full Name', value: fullName),
              _buildProfileItem(
                  icon: Icons.email, title: 'Email Address', value: email),
              _buildProfileItem(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: _guest?.contactNumber ?? 'Not provided'),
              _buildProfileItem(
                  icon: Icons.location_on,
                  title: 'Address',
                  value: _guest?.address ?? 'Not provided'),
            ],
          ),
          const SizedBox(height: 24),
          _buildProfileSection(
            title: 'Identity Details',
            children: [
              _buildProfileItem(
                  icon: Icons.badge,
                  title: 'ID Type',
                  value: _guest?.idType ?? 'N/A'),
              _buildProfileItem(
                  icon: Icons.numbers,
                  title: 'ID Number',
                  value: _guest?.idNumber ?? 'N/A'),
              _buildProfileItem(
                  icon: Icons.public,
                  title: 'Nationality',
                  value: _guest?.nationality ?? 'N/A'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfileItem(
      {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
