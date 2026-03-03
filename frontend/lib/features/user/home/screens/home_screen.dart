import 'package:flutter/material.dart';
import 'dart:ui';

import '../../../../models/user.dart';
import '../../../../theme/app_colors.dart';
import '../../booking/screens/bill_screen.dart';
import '../../../auth/screens/login_screen.dart';
import '../../booking/screens/new_reservation_screen.dart';
import '../../booking/screens/view_reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Dynamic background pattern (Consistent with Landing Screen)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.3,
                  child: CustomPaint(
                    painter: BackgroundPainter(_bounceController.value),
                  ),
                );
              },
            ),
          ),

          // Background decorative elements
          _buildBackgroundDecor(),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
              child: FadeTransition(
                opacity: _fadeController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 40),
                    _buildWelcomeSection(context),
                    const SizedBox(height: 50),
                    Text(
                      'Management Dashboard',
                      style: TextStyle(
                        color: AppColors.textLight.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildActionGrid(context),
                    const SizedBox(height: 60),
                    _buildFooterInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OCEAN VIEW',
              style: TextStyle(
                color: AppColors.goldAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'RESORT & SPA',
              style: TextStyle(
                color: AppColors.textLight.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.glassLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.person_outline, color: AppColors.goldAccent),
            offset: const Offset(0, 50),
            color: AppColors.darkBgSecondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.account_circle_outlined,
                        size: 20, color: AppColors.textLight),
                    const SizedBox(width: 10),
                    Text('Profile',
                        style: TextStyle(color: AppColors.textLight)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout,
                        size: 20, color: Colors.redAccent.shade100),
                    const SizedBox(width: 10),
                    Text('Logout',
                        style: TextStyle(color: Colors.redAccent.shade100)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.glassLight,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.glassBorder),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldAccent.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.user.username[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBg,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: AppColors.textLight.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.6,
      children: [
        _buildActionCard(
          context,
          icon: Icons.add_home_outlined,
          title: 'New Booking',
          subtitle: 'Create a new reservation',
          color: AppColors.goldAccent,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    NewReservationScreen(userId: widget.user.userId),
              ),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.calendar_month_outlined,
          title: 'Your Bookings',
          subtitle: 'Manage active reservations',
          color: AppColors.sageGreen,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ViewReservationsScreen(guestId: widget.user.userId),
              ),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.receipt_long_outlined,
          title: 'Billing history',
          subtitle: 'Check invoices and bills',
          color: Colors.blueAccent.shade100,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const BillScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.darkBgSecondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
                border:
                    Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Center(
      child: Column(
        children: [
          Container(
            height: 1,
            width: 100,
            color: AppColors.goldAccent.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          Text(
            'Experience the Pinnacle of Luxury',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -150 + (_bounceController.value * 30),
              right: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldAccent.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -100 - (_bounceController.value * 20),
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sageGreen.withOpacity(0.04),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;
  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.02)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final offset = animationValue * 40;
      canvas.drawCircle(
        Offset(size.width * 0.1 + (i * 200) + offset, size.height * 0.3),
        150 + (animationValue * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
