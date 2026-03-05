import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF1565C0),
                  child: Text(
                    'S',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sri Kumar',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D47A1),
                  ),
                ),
                Text(
                  'sri@oceanview.com',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey.shade600,
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
                  icon: Icons.person, title: 'Full Name', value: 'Sri Kumar'),
              _buildProfileItem(
                  icon: Icons.email,
                  title: 'Email Address',
                  value: 'sri@oceanview.com'),
              _buildProfileItem(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: '+94 77 111 2233'),
              _buildProfileItem(
                  icon: Icons.location_on,
                  title: 'Address',
                  value: '42 Beach Road, Colombo'),
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
            color: Colors.black.withOpacity(0.05),
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
