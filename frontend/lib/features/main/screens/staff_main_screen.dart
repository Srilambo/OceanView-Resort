import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/navigation/sidebar_navigation.dart';
import '../../../shared/navigation/top_navigation.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({Key? key}) : super(key: key);

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _currentRoute = '/staff/home';

  final List<NavigationItem> staffNavItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard,
      route: '/staff/home',
    ),
    NavigationItem(
      label: 'Check-in',
      icon: Icons.person_add,
      route: '/staff/checkin',
    ),
    NavigationItem(
      label: 'Check-out',
      icon: Icons.person_remove,
      route: '/staff/checkout',
    ),
    NavigationItem(
      label: 'Room Status',
      icon: Icons.hotel,
      route: '/staff/rooms',
    ),
    NavigationItem(
      label: 'Tasks',
      icon: Icons.assignment,
      route: '/staff/tasks',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavigationBar(
        title: 'Staff Portal',
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: Drawer(
        child: SidebarNavigation(
          currentRoute: _currentRoute,
          items: staffNavItems,
        ),
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900)
            SidebarNavigation(
              currentRoute: _currentRoute,
              items: staffNavItems,
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
                      'Daily Operations',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Task Cards
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 900
                          ? 3
                          : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        _buildTaskCard(
                          '5',
                          'Pending Check-ins',
                          Icons.person_add,
                          Colors.blue,
                          () {},
                        ),
                        _buildTaskCard(
                          '3',
                          'Check-outs',
                          Icons.person_remove,
                          Colors.orange,
                          () {},
                        ),
                        _buildTaskCard(
                          '8',
                          'Maintenance',
                          Icons.home_repair_service,
                          Colors.green,
                          () {},
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

  Widget _buildTaskCard(
    String count,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
              const SizedBox(height: 12),
              Text(
                count,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
