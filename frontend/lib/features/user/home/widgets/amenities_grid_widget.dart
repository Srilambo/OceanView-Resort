import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';

class AmenitiesGridWidget extends StatelessWidget {
  const AmenitiesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final amenities = [
      (Icons.restaurant, 'Fine Dining'),
      (Icons.spa, 'Spa & Wellness'),
      (Icons.fitness_center, 'Fitness Center'),
      (Icons.local_bar, 'Bar & Lounge'),
      (Icons.sports_tennis, 'Sports'),
      (Icons.sports_esports, 'Entertainment'),
      (Icons.wifi, 'Free WiFi'),
      (Icons.security, '24/7 Security'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
      color: Colors.white.withValues(alpha: 0.02),
      child: Column(
        children: [
          Text(
            'OUR AMENITIES',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.cream,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
            ),
            itemCount: amenities.length,
            itemBuilder: (context, index) {
              return _GlassAmenityCard(
                icon: amenities[index].$1,
                label: amenities[index].$2,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GlassAmenityCard extends StatefulWidget {
  final IconData icon;
  final String label;

  const _GlassAmenityCard({required this.icon, required this.label});

  @override
  State<_GlassAmenityCard> createState() => _GlassAmenityCardState();
}

class _GlassAmenityCardState extends State<_GlassAmenityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.04),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldAccent
                : Colors.white.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 28,
              color: _isHovered ? AppColors.goldAccent : AppColors.textLight,
            ),
            const SizedBox(height: 12),
            Text(
              widget.label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _isHovered ? AppColors.goldAccent : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
