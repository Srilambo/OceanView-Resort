import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/screens/login_screen.dart';
import '../../../../theme/app_colors.dart';
import '../../rooms/screens/rooms_screen.dart';
import '../../amenities/screens/amenities_screen.dart';
import '../../offers/screens/offers_screen.dart';
import '../../contact/screens/contact_screen.dart';
import '../screens/landing_screen.dart';

class HeaderWidget extends StatelessWidget {
  final Animation<double>? fadeAnimation;

  const HeaderWidget({
    super.key,
    this.fadeAnimation,
  });

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide a default animation if fadeAnimation is null
    final Animation<double> effectiveFadeAnimation =
        fadeAnimation ?? const AlwaysStoppedAnimation(1.0);

    return FadeTransition(
      opacity: effectiveFadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.darkBg.withValues(alpha: 0.7),
          border: Border(
            bottom: BorderSide(
              color: AppColors.goldAccent.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo with scale animation
            ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                    parent: effectiveFadeAnimation, curve: Curves.easeOut),
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LandingScreen()),
                      (route) => false,
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.goldAccent.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.waves,
                          color: AppColors.darkBg,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OCEAN VIEW',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.cream,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'RESORT & SPA',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: AppColors.textMuted,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Navigation
            Row(
              children: [
                _buildNavItem(
                    'ROOMS', () => _navigateTo(context, const RoomsScreen())),
                _buildNavItem('AMENITIES',
                    () => _navigateTo(context, const AmenitiesScreen())),
                _buildNavItem(
                    'OFFERS', () => _navigateTo(context, const OffersScreen())),
                _buildNavItem('CONTACT',
                    () => _navigateTo(context, const ContactScreen())),
              ],
            ),

            // Right actions
            Row(
              children: [
                // Sign In Button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.goldAccent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SIGN IN',
                        style: GoogleFonts.poppins(
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Book Now Button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Trigger scroll to booking section or navigate
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldAccent.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        'BOOK NOW',
                        style: GoogleFonts.poppins(
                          color: AppColors.darkBg,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, VoidCallback onTap) {
    return _NavLink(label: label, onTap: onTap);
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      _isHovered ? AppColors.goldAccent : AppColors.textLight,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _isHovered ? 24 : 0,
                decoration: BoxDecoration(
                  color: AppColors.goldAccent,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.goldAccent.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
