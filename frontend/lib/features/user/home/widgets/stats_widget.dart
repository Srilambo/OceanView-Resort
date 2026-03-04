import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _StatItem(number: '50+', label: 'LUXURY ROOMS', index: 0),
          _StatItem(
              number: '4.9', label: 'GUEST RATING', icon: Icons.star, index: 1),
          _StatItem(number: '10K+', label: 'HAPPY GUESTS', index: 2),
          _StatItem(number: '25+', label: 'YEARS LEGACY', index: 3),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final IconData? icon;
  final int index;

  const _StatItem({
    required this.number,
    required this.label,
    this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000 + (index * 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null)
                      Icon(icon, color: AppColors.goldAccent, size: 28),
                    if (icon != null) const SizedBox(width: 8),
                    Text(
                      number,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight.withOpacity(0.6),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

