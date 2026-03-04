import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/navigation/sidebar_navigation.dart';
import '../../../shared/navigation/top_navigation.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _currentRoute = '/admin/home';

  final List<NavigationItem> adminNavItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard,
      route: '/admin/home',
    ),
    NavigationItem(
      label: 'Users',
      icon: Icons.people,
      route: '/admin/users',
    ),
    NavigationItem(
      label: 'Rooms',
      icon: Icons.hotel,
      route: '/admin/rooms',
    ),
    NavigationItem(
      label: 'Bookings',
      icon: Icons.event_note,
      route: '/admin/bookings',
    ),
    NavigationItem(
      label: 'Reports',
      icon: Icons.assessment,
      route: '/admin/reports',
    ),
    NavigationItem(
      label: 'Settings',
      icon: Icons.settings,
      route: '/admin/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavigationBar(
        title: 'Admin Dashboard',
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: Drawer(
        child: SidebarNavigation(
          currentRoute: _currentRoute,
          items: adminNavItems,
        ),
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900)
            SidebarNavigation(
              currentRoute: _currentRoute,
              items: adminNavItems,
            ),
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Control Panel',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // KPI Cards
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 1200
                          ? 4
                          : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        _buildKPICard('Total Users', '250', Icons.people,
                            const Color(0xFF1565C0)),
                        _buildKPICard('Active Bookings', '45', Icons.event_note,
                            const Color(0xFFF57C00)),
                        _buildKPICard('Total Rooms', '50', Icons.hotel,
                            const Color(0xFF009688)),
                        _buildKPICard('Revenue', '\$45,250', Icons.attach_money,
                            const Color(0xFF7B2D26)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Management Sections
                    GridView.count(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 900 ? 2 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildManagementCard(
                          icon: Icons.person_add,
                          title: 'User Management',
                          description: 'Manage users and roles',
                          color: const Color(0xFF1565C0),
                          onTap: () {},
                        ),
                        _buildManagementCard(
                          icon: Icons.home,
                          title: 'Room Management',
                          description: 'Add, edit, delete rooms',
                          color: const Color(0xFF009688),
                          onTap: () {},
                        ),
                        _buildManagementCard(
                          icon: Icons.assessment,
                          title: 'Reports',
                          description: 'View system reports',
                          color: const Color(0xFFF57C00),
                          onTap: () {},
                        ),
                        _buildManagementCard(
                          icon: Icons.settings,
                          title: 'Settings',
                          description: 'System configuration',
                          color: const Color(0xFF7B2D26),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
