import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocean_view_resort_app/features/authentication/screens/login_screen.dart';
import '../../../../theme/app_colors.dart';

class HeroSectionWidget extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final double scrollProgress;

  const HeroSectionWidget({
    super.key,
    required this.fadeAnimation,
    required this.scrollProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2845).withOpacity(0.85),
            const Color(0xFF0F3460).withOpacity(0.85),
          ],
        ),
        image: DecorationImage(
          image: const AssetImage('assets/images/hero_beach_landing.png'),
          fit: BoxFit.cover,
          opacity: (0.25 + (scrollProgress * 0.1)).clamp(0, 1),
          onError: (exception, stackTrace) {},
        ),
      ),
      child: Stack(
        children: [
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.darkBg.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Content
          Center(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(parent: fadeAnimation, curve: Curves.easeOut),
              ),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Experience',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cream,
                        letterSpacing: 2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.goldGradient.createShader(bounds),
                      child: Text(
                        'Nature in Luxury',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Discover the perfect beachside escape at Ocean View Resort',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildCtaButton(context, 'BOOK YOUR STAY'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withOpacity(0.4),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.darkBg,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBg,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
