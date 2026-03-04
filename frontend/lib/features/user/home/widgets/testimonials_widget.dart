import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';

class TestimonialsWidget extends StatelessWidget {
  const TestimonialsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      (
        'Sarah Anderson',
        'Absolutely stunning! The views are breathtaking and service is exceptional.',
        5
      ),
      (
        'James Mitchell',
        'Outstanding experience! Luxury and comfort combined perfectly.',
        5
      ),
      (
        'Emma Watson',
        'Perfect getaway! Will definitely return to this paradise.',
        5
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
      color: Colors.white.withOpacity(0.02),
      child: Column(
        children: [
          Text(
            'GUEST TESTIMONIALS',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.cream,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            children: testimonials
                .map((t) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _GlassTestimonialCard(
                          name: t.$1,
                          text: t.$2,
                          rating: t.$3,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _GlassTestimonialCard extends StatelessWidget {
  final String name;
  final String text;
  final int rating;

  const _GlassTestimonialCard({
    required this.name,
    required this.text,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              rating,
              (index) =>
                  const Icon(Icons.star, color: AppColors.goldAccent, size: 16),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"$text"',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            name.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.goldAccent,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

