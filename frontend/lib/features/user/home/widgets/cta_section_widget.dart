import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocean_view_resort_app/features/authentication/screens/login_screen.dart';
import '../../../../theme/app_colors.dart';

class CtaSectionWidget extends StatelessWidget {
  const CtaSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            'Ready for Your Dream Escape?',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.cream,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Join hundreds of satisfied guests who have discovered paradise at Ocean View Resort. Book your unforgettable beachside experience today.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textLight.withOpacity(0.8),
              height: 1.8,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildPrimaryButton(context, 'BOOK YOUR STAY NOW'),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withOpacity(0.4),
            blurRadius: 30,
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBg,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

