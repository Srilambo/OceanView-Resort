import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/navigation/sidebar_navigation.dart';
import '../../../shared/navigation/top_navigation.dart';
import '../../../services/api_service.dart';
import '../../../models/staff.dart';
import 'staff_views/tasks_view.dart';
import 'staff_views/check_in_view.dart';
import 'staff_views/check_out_view.dart';
import 'staff_views/room_status_view.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({Key? key}) : super(key: key);

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentRoute = '/staff/home';

  Map<String, dynamic>? _stats;
  List<Staff>? _recentStaff;
  bool _isLoading = true;
  String? _error;

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
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        ApiService.getStaffStats(),
        ApiService.getAllStaff(),
      ]);

      setState(() {
        _stats = results[0] as Map<String, dynamic>;
        _recentStaff = results[1] as List<Staff>;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;

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
              onRouteSelect: (route) {
                setState(() => _currentRoute = route);
                if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                SidebarNavigation(
                  currentRoute: _currentRoute,
                  items: staffNavItems,
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
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(BoxConstraints constraints) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _buildErrorView();
    }

    switch (_currentRoute) {
      case '/staff/home':
        return _buildDashboardContent(constraints);
      case '/staff/checkin':
        return const CheckInView();
      case '/staff/checkout':
        return const CheckOutView();
      case '/staff/rooms':
        return const RoomStatusView();
      case '/staff/tasks':
        return const TasksView();
      default:
        return _buildDashboardContent(constraints);
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load data',
            style: GoogleFonts.montserrat(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final totalActive = _stats?['totalActiveStaff'] ?? 0;
    final frontDesk = _stats?['frontDesk'] ?? 0;
    final housekeeping = _stats?['housekeeping'] ?? 0;
    final maintenance = _stats?['maintenance'] ?? 0;
    final restaurant = _stats?['restaurant'] ?? 0;
    final security = _stats?['security'] ?? 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaffHeader(),
            const SizedBox(height: 24),

            // Summary Stats
            GridView.count(
              crossAxisCount: width > 900 ? 3 : (width > 600 ? 2 : 1),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildTaskCard(
                  totalActive.toString(),
                  'Active Staff',
                  Icons.people,
                  Colors.blue,
                  () {},
                ),
                _buildTaskCard(
                  frontDesk.toString(),
                  'Front Desk',
                  Icons.desk,
                  const Color(0xFF1565C0),
                  () {},
                ),
                _buildTaskCard(
                  housekeeping.toString(),
                  'Housekeeping',
                  Icons.cleaning_services,
                  const Color(0xFF2E7D32),
                  () {},
                ),
                _buildTaskCard(
                  restaurant.toString(),
                  'Restaurant',
                  Icons.restaurant,
                  const Color(0xFF6A1B9A),
                  () {},
                ),
                _buildTaskCard(
                  maintenance.toString(),
                  'Maintenance',
                  Icons.build,
                  const Color(0xFFE65100),
                  () {},
                ),
                _buildTaskCard(
                  security.toString(),
                  'Security',
                  Icons.security,
                  const Color(0xFFC62828),
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Staff List
            Text(
              'Team Members',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 16),

            if (_recentStaff != null && _recentStaff!.isNotEmpty)
              Container(
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
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentStaff!.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade200, height: 1),
                  itemBuilder: (context, index) {
                    final staff = _recentStaff![index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: _getDepartmentColor(
                          staff.department,
                        ).withOpacity(0.1),
                        child: Text(
                          staff.fullName.isNotEmpty
                              ? staff.fullName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: _getDepartmentColor(staff.department),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        staff.fullName,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D47A1),
                        ),
                      ),
                      subtitle: Text(
                        '${staff.position} • ${staff.department.replaceAll('_', ' ')}',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: staff.status == 'ACTIVE'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              staff.status,
                              style: GoogleFonts.montserrat(
                                color: staff.status == 'ACTIVE'
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              staff.shift,
                              style: GoogleFonts.montserrat(
                                color: Colors.blue,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'No staff members found.',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/hero_beach_landing.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            colors: [
              const Color(0xFF1565C0).withOpacity(0.9),
              const Color(0xFF1565C0).withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ops Terminal',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daily operations and task management',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.small(
                    onPressed: _loadData,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.refresh, color: Color(0xFF1565C0)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Refresh',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDepartmentColor(String department) {
    switch (department) {
      case 'FRONT_DESK':
        return const Color(0xFF1565C0);
      case 'HOUSEKEEPING':
        return const Color(0xFF2E7D32);
      case 'MAINTENANCE':
        return const Color(0xFFE65100);
      case 'RESTAURANT':
        return const Color(0xFF6A1B9A);
      case 'SECURITY':
        return const Color(0xFFC62828);
      case 'MANAGEMENT':
        return const Color(0xFF00838F);
      default:
        return Colors.grey;
    }
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
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
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
