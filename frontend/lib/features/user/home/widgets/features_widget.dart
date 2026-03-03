import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';

class FeaturesWidget extends StatelessWidget {
  const FeaturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.hotel, 'SPACIOUS ROOMS', 'Elegantly designed suites'),
      (Icons.people, 'GUEST SERVICES', 'Dedicated management'),
      (Icons.calendar_today, 'EASY BOOKING', 'Real-time availability'),
      (Icons.waves, 'OCEAN VIEWS', 'Pristine coastline'),
      (Icons.receipt_long, 'TRANSPARENT BILLING', 'No hidden charges'),
      (Icons.security, 'SECURE BOOKING', 'Protected information'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
      child: Column(
        children: [
          Text(
            'WHY CHOOSE US',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.cream,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Experience luxury beachside living with world-class amenities',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textLight,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.1,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return _buildFeatureCard(
                features[index].$1,
                features[index].$2,
                features[index].$3,
                index,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String desc, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 800 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 30),
          child: Opacity(
            opacity: value,
            child: _FeatureCard(
              icon: icon,
              title: title,
              description: desc,
            ),
          ),
        );
      },
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.05),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldAccent
                : Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.goldAccent.withValues(alpha: 0.2),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              widget.icon,
              size: 40,
              color: AppColors.goldAccent,
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.cream,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
