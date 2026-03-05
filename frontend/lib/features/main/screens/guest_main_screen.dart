import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../../../shared/navigation/sidebar_navigation.dart';
import '../../../shared/navigation/top_navigation.dart';
import 'guest_views/browse_rooms_view.dart';
import 'guest_views/my_bookings_view.dart';
import 'guest_views/services_view.dart';
import 'guest_views/reviews_view.dart';
import 'guest_views/my_profile_view.dart';
import 'guest_views/bill_screen.dart';
import '../../../services/api_service.dart';

class GuestMainScreen extends StatefulWidget {
  const GuestMainScreen({Key? key}) : super(key: key);

  @override
  State<GuestMainScreen> createState() => _GuestMainScreenState();
}

class _GuestMainScreenState extends State<GuestMainScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentRoute = '/guest/home';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<NavigationItem> guestNavItems = [
    NavigationItem(
        label: 'Home', icon: Icons.home_rounded, route: '/guest/home'),
    NavigationItem(
        label: 'Browse Rooms',
        icon: Icons.hotel_rounded,
        route: '/guest/rooms'),
    NavigationItem(
        label: 'My Bookings',
        icon: Icons.event_note_rounded,
        route: '/guest/bookings'),
    NavigationItem(
        label: 'Services', icon: Icons.spa_rounded, route: '/guest/services'),
    NavigationItem(
        label: 'Reviews', icon: Icons.star_rounded, route: '/guest/reviews'),
    NavigationItem(
        label: 'My Profile',
        icon: Icons.person_rounded,
        route: '/guest/profile'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigate(String route) {
    setState(() => _currentRoute = route);
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF8F9FC),
          appBar: TopNavigationBar(
            title: _getPageTitle(),
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          drawer: Drawer(
            child: SidebarNavigation(
              currentRoute: _currentRoute,
              items: guestNavItems,
              onRouteSelect: (route) {
                _navigate(route);
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
                  items: guestNavItems,
                  onRouteSelect: _navigate,
                ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildBodyContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getPageTitle() {
    switch (_currentRoute) {
      case '/guest/home':
        return 'Guest Dashboard';
      case '/guest/rooms':
        return 'Browse Rooms';
      case '/guest/bookings':
        return 'My Bookings';
      case '/guest/services':
        return 'Resort Services';
      case '/guest/reviews':
        return 'Guest Reviews';
      case '/guest/profile':
        return 'My Profile';
      default:
        return 'Guest Dashboard';
    }
  }

  Widget _buildBodyContent() {
    switch (_currentRoute) {
      case '/guest/home':
        return _buildDashboard();
      case '/guest/rooms':
        return const BrowseRoomsView();
      case '/guest/bookings':
        return const MyBookingsView();
      case '/guest/services':
        return const ServicesView();
      case '/guest/reviews':
        return const ReviewsView();
      case '/guest/profile':
        return const MyProfileView();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    final username = user?.username ?? 'Guest';

    return FutureBuilder<Map<String, dynamic>?>(
      future: user != null ? _fetchActiveStayInfo(user.id) : Future.value(null),
      builder: (context, snapshot) {
        final stayInfo = snapshot.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Hero Welcome Banner ──────────────────────────────────────────
              _buildWelcomeBanner(username, stayInfo),
              const SizedBox(height: 36),

              // ─── Stats Row ────────────────────────────────────────────────────
              _buildStatsRow(),
              const SizedBox(height: 36),

              // ─── Quick Actions ────────────────────────────────────────────────
              _buildSectionTitle('Quick Actions', Icons.bolt_rounded),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 36),

              // ─── Featured Rooms & What's Available ───────────────────────────
              _buildSectionTitle(
                  'Featured Experiences', Icons.auto_awesome_rounded),
              const SizedBox(height: 20),
              _buildFeaturedCards(),
              const SizedBox(height: 36),

              // ─── Stay Highlights ─────────────────────────────────────────────
              _buildSectionTitle('Resort Highlights', Icons.star_rounded),
              const SizedBox(height: 20),
              _buildResortHighlights(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _fetchActiveStayInfo(String userId) async {
    try {
      final guest = await ApiService.getGuestByUserId(userId);
      final reservations = await ApiService.getGuestReservations(guest.guestId);
      final active =
          reservations.where((r) => r.status == 'CHECKED_IN').toList();

      if (active.isNotEmpty) {
        final res = active.first;
        final bill = await ApiService.getBillDetails(res.reservationId);
        return {
          'reservation': res,
          'bill': bill,
        };
      }
    } catch (_) {}
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Welcome Banner
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildWelcomeBanner(String username, Map<String, dynamic>? stayInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: stayInfo != null
              ? [
                  const Color(0xFF1B5E20),
                  const Color(0xFF2E7D32),
                  const Color(0xFF388E3C)
                ]
              : [
                  const Color(0xFF0D47A1),
                  const Color(0xFF1565C0),
                  const Color(0xFF1976D2)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.3),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        return isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerText(username, stayInfo),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildBannerIcon(stayInfo),
                      const SizedBox(width: 24),
                      _buildBannerButton(stayInfo)
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildBannerText(username, stayInfo)),
                  const SizedBox(width: 32),
                  _buildBannerIcon(stayInfo),
                  const SizedBox(width: 32),
                  _buildBannerButton(stayInfo),
                ],
              );
      }),
    );
  }

  Widget _buildBannerText(String username, Map<String, dynamic>? stayInfo) {
    final bool isCheckedIn = stayInfo != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isCheckedIn
              ? 'Welcome Home, $username! 🏨'
              : 'Welcome back, $username! 👋',
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isCheckedIn
              ? 'You are currently checked into Room ${stayInfo['reservation'].roomNumber}.\nYour current bill total is \$${(stayInfo['bill']['grandTotal'] as num).toStringAsFixed(2)}.'
              : 'Your luxury escape at Ocean View Resort awaits.\nExplore rooms, services, and more below.',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white.withOpacity(0.85),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerIcon(Map<String, dynamic>? stayInfo) {
    final isCheckedIn = stayInfo != null;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(
          isCheckedIn ? Icons.receipt_long_rounded : Icons.waves_rounded,
          size: 52,
          color: Colors.white),
    );
  }

  Widget _buildBannerButton(Map<String, dynamic>? stayInfo) {
    final isCheckedIn = stayInfo != null;
    return ElevatedButton.icon(
      onPressed: () {
        if (isCheckedIn) {
          _showActiveBill(stayInfo);
        } else {
          _navigate('/guest/rooms');
        }
      },
      icon: Icon(isCheckedIn ? Icons.visibility_rounded : Icons.search_rounded,
          size: 18),
      label: Text(
        isCheckedIn ? 'View My Bill' : 'Browse Rooms',
        style:
            GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor:
            isCheckedIn ? const Color(0xFF1B5E20) : const Color(0xFF0D47A1),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    );
  }

  void _showActiveBill(Map<String, dynamic> stayInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BillScreen(
          reservationId: stayInfo['reservation'].reservationId,
          reservationNumber: stayInfo['reservation'].reservationNumber,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Stats Row
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final stats = [
      {
        'icon': Icons.bed_rounded,
        'label': 'Room Types',
        'value': '6',
        'color': const Color(0xFF1565C0)
      },
      {
        'icon': Icons.spa_rounded,
        'label': 'Services',
        'value': '8+',
        'color': const Color(0xFF2E7D32)
      },
      {
        'icon': Icons.star_rounded,
        'label': 'Reviews',
        'value': '5★',
        'color': const Color(0xFFF57C00)
      },
      {
        'icon': Icons.support_agent_rounded,
        'label': 'Support',
        'value': '24/7',
        'color': const Color(0xFF7B1FA2)
      },
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 800 ? 4 : 2;
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
        children: stats.map((s) => _buildStatCard(s)).toList(),
      );
    });
  }

  Widget _buildStatCard(Map<String, dynamic> s) {
    final color = s['color'] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(s['icon'] as IconData, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s['value'] as String,
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                s['label'] as String,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Quick Actions
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.add_business_rounded,
        'title': 'New Booking',
        'subtitle': 'Reserve your perfect room',
        'color': const Color(0xFF1565C0),
        'route': '/guest/rooms',
      },
      {
        'icon': Icons.event_note_rounded,
        'title': 'My Bookings',
        'subtitle': 'View & manage reservations',
        'color': const Color(0xFFF57C00),
        'route': '/guest/bookings',
      },
      {
        'icon': Icons.spa_rounded,
        'title': 'Services',
        'subtitle': 'Spa, dining & adventures',
        'color': const Color(0xFF2E7D32),
        'route': '/guest/services',
      },
      {
        'icon': Icons.rate_review_rounded,
        'title': 'Leave a Review',
        'subtitle': 'Share your experience',
        'color': const Color(0xFF7B1FA2),
        'route': '/guest/reviews',
      },
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final cols =
          constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: cols == 4 ? 1.8 : (cols == 2 ? 2.0 : 4.0),
        children: actions.map((a) => _buildActionCard(a)).toList(),
      );
    });
  }

  Widget _buildActionCard(Map<String, dynamic> a) {
    final color = a['color'] as Color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigate(a['route'] as String),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:
                    Icon(a['icon'] as IconData, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      a['title'] as String,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      a['subtitle'] as String,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: color.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Featured Cards
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildFeaturedCards() {
    final features = [
      {
        'title': 'Deluxe Ocean Rooms',
        'desc':
            'King-size bed, private balcony and breathtaking ocean views from every angle.',
        'icon': Icons.king_bed_rounded,
        'badge': 'From \$150/night',
        'gradient': [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
        'image': 'assets/images/room1_ocean_suite_img2.png',
      },
      {
        'title': 'Presidential Suites',
        'desc':
            'Private jacuzzi, butler service and panoramic views in our flagship suites.',
        'icon': Icons.villa_rounded,
        'badge': 'From \$300/night',
        'gradient': [const Color(0xFF4A148C), const Color(0xFF7B1FA2)],
        'image': 'assets/images/room3_presidential_suite_img1.png',
      },
      {
        'title': 'Ocean Breeze Spa',
        'desc':
            'Full body massage, aromatherapy and hot stone therapy with ocean views.',
        'icon': Icons.spa_rounded,
        'badge': '\$120 per session',
        'gradient': [const Color(0xFF1B5E20), const Color(0xFF388E3C)],
        'image': 'assets/images/luxury_pool.png',
      },
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final cols =
          constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1);
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: features.map((f) => _buildFeatureCard(f)).toList(),
      );
    });
  }

  Widget _buildFeatureCard(Map<String, dynamic> f) {
    final gradient = f['gradient'] as List<Color>;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          if (f['image'] != null)
            Positioned.fill(
              child: Image.asset(
                f['image'] as String,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        f['icon'] as IconData,
                        size: 60,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradient[0].withOpacity(0.85),
                    gradient[1].withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Decorative circle
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(f['icon'] as IconData,
                      color: Colors.white, size: 28),
                ),
                const Spacer(),
                Text(
                  f['title'] as String,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  f['desc'] as String,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    f['badge'] as String,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Resort Highlights
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildResortHighlights() {
    final highlights = [
      {
        'icon': Icons.pool_rounded,
        'label': 'Infinity Pool',
        'sub': 'Overlooking the ocean',
        'color': const Color(0xFF0288D1),
        'image': 'assets/images/luxury_pool.png',
      },
      {
        'icon': Icons.restaurant_rounded,
        'label': 'The Pearl',
        'sub': 'Award-winning',
        'color': const Color(0xFFF57C00),
        'image': 'assets/images/room1_ocean_suite_img2.png',
      },
      {
        'icon': Icons.beach_access_rounded,
        'label': 'Private Beach',
        'sub': 'Exclusive access',
        'color': const Color(0xFF00897B),
        'image': 'assets/images/hero_beach_landing.png',
      },
      {
        'icon': Icons.fitness_center_rounded,
        'label': 'Fitness & Yoga',
        'sub': 'Sunrise sessions',
        'color': const Color(0xFF6D4C41),
        'image': 'assets/images/room2_garden_deluxe_img1.png',
      },
      {
        'icon': Icons.directions_boat_rounded,
        'label': 'Island Tours',
        'sub': 'Snorkeling & more',
        'color': const Color(0xFF1565C0),
        'image': 'assets/images/resort_hero.png',
      },
      {
        'icon': Icons.child_care_rounded,
        'label': 'Kids Club',
        'sub': 'Fun for all ages',
        'color': const Color(0xFFAD1457),
        'image': 'assets/images/room1_ocean_suite_img1.png',
      },
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final cols =
          constraints.maxWidth > 900 ? 6 : (constraints.maxWidth > 600 ? 3 : 2);
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: highlights.map((h) {
          final color = h['color'] as Color;
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.12)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Image with heavy opacity
                Positioned.fill(
                  child: Image.asset(
                    h['image'] as String,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(h['icon'] as IconData, color: color, size: 20),
                      ),
                      const Spacer(),
                      Text(
                        h['label'] as String,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        h['sub'] as String,
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D47A1), size: 22),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
