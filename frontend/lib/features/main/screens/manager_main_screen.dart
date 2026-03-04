import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/navigation/sidebar_navigation.dart';
import '../../../shared/navigation/top_navigation.dart';

class ManagerMainScreen extends StatefulWidget {
  const ManagerMainScreen({Key? key}) : super(key: key);

  @override
  State<ManagerMainScreen> createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _currentRoute = '/manager/home';

  final List<NavigationItem> managerNavItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard,
      route: '/manager/home',
    ),
    NavigationItem(
      label: 'Revenue',
      icon: Icons.attach_money,
      route: '/manager/revenue',
    ),
    NavigationItem(
      label: 'Occupancy',
      icon: Icons.hotel,
      route: '/manager/occupancy',
    ),
    NavigationItem(
      label: 'Analytics',
      icon: Icons.analytics,
      route: '/manager/analytics',
    ),
    NavigationItem(
      label: 'Reports',
      icon: Icons.assessment,
      route: '/manager/reports',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavigationBar(
        title: 'Manager Dashboard',
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: Drawer(
        child: SidebarNavigation(
          currentRoute: _currentRoute,
          items: managerNavItems,
        ),
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900)
            SidebarNavigation(
              currentRoute: _currentRoute,
              items: managerNavItems,
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
                      'Business Analytics',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // KPIs
                    GridView.count(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 900 ? 2 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        _buildAnalyticsCard(
                          '85%',
                          'Occupancy Rate',
                          Icons.hotel,
                          Colors.blue,
                        ),
                        _buildAnalyticsCard(
                          '\$45,250',
                          'Monthly Revenue',
                          Icons.attach_money,
                          Colors.green,
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

  Widget _buildAnalyticsCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 40),
          ),
        ],
      ),
    );
  }
}
