import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/navigation/sidebar_navigation.dart';
import '../../../shared/navigation/top_navigation.dart';
import 'admin_views/user_management_view.dart';
import 'admin_views/room_management_view.dart';
import 'admin_views/booking_management_view.dart';
import 'admin_views/reports_view.dart';
import 'admin_views/settings_view.dart';
import 'staff_views/tasks_view.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentRoute = '/admin/home';

  final List<NavigationItem> adminNavItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard,
      route: '/admin/home',
    ),
    NavigationItem(
      label: 'Accounts',
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
      label: 'Tasks',
      icon: Icons.assignment,
      route: '/admin/tasks',
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
          onRouteSelect: (route) {
            setState(() => _currentRoute = route);
            if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
              _scaffoldKey.currentState?.closeDrawer();
            }
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 900;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                SidebarNavigation(
                  currentRoute: _currentRoute,
                  items: adminNavItems,
                  onRouteSelect: (route) {
                    setState(() => _currentRoute = route);
                  },
                ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade50,
                  child: _buildBodyContent(constraints),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBodyContent(BoxConstraints constraints) {
    switch (_currentRoute) {
      case '/admin/home':
        return _buildDashboard(constraints);
      case '/admin/users':
        return const UserManagementView();
      case '/admin/rooms':
        return const RoomManagementView();
      case '/admin/bookings':
        return const BookingManagementView();
      case '/admin/reports':
        return const ReportsView();
      case '/admin/tasks':
        return const TasksView();
      case '/admin/settings':
        return const SettingsView();
      default:
        return _buildDashboard(constraints);
    }
  }

  Widget _buildDashboard(BoxConstraints constraints) {
    final double width = constraints.maxWidth;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),

          // KPI Cards
          GridView.count(
            crossAxisCount: width > 1200 ? 4 : (width > 600 ? 2 : 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: width > 1200 ? 2.5 : 2.0,
            children: [
              _buildKPICard(
                  'Total Users', '250', Icons.people, const Color(0xFF1565C0)),
              _buildKPICard('Active Bookings', '45', Icons.event_note,
                  const Color(0xFFF57C00)),
              _buildKPICard(
                  'Total Rooms', '50', Icons.hotel, const Color(0xFF009688)),
              _buildKPICard('Revenue', '\$45,250', Icons.attach_money,
                  const Color(0xFF7B2D26)),
            ],
          ),

          const SizedBox(height: 30),

          // Management Sections
          GridView.count(
            crossAxisCount: width > 900 ? 2 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: width > 900 ? 1.5 : 1.2,
            children: [
              _buildManagementCard(
                icon: Icons.person_add,
                title: 'Accounts Management',
                description: 'Manage users and roles',
                color: const Color(0xFF1565C0),
                onTap: () {
                  setState(() => _currentRoute = '/admin/users');
                },
              ),
              _buildManagementCard(
                icon: Icons.home,
                title: 'Room Management',
                description: 'Add, edit, delete rooms',
                color: const Color(0xFF009688),
                onTap: () {
                  setState(() => _currentRoute = '/admin/rooms');
                },
              ),
              _buildManagementCard(
                icon: Icons.assessment,
                title: 'Reports',
                description: 'View system reports',
                color: const Color(0xFFF57C00),
                onTap: () {
                  setState(() => _currentRoute = '/admin/reports');
                },
              ),
              _buildManagementCard(
                icon: Icons.settings,
                title: 'Settings',
                description: 'System configuration',
                color: const Color(0xFF7B2D26),
                onTap: () {
                  setState(() => _currentRoute = '/admin/settings');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/resort_hero.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D47A1).withOpacity(0.8),
              const Color(0xFF0D47A1).withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Command Center',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Oversee all operations of Ocean View Resort',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
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
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
