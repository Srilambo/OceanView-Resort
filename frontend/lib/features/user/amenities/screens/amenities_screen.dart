import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../home/widgets/header_widget.dart';
import '../../home/widgets/footer_widget.dart';

class AmenitiesScreen extends StatelessWidget {
  const AmenitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkBg,
                  AppColors.darkBgSecondary,
                  AppColors.darkBgTertiary,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),

                // Hero Section for Amenities
                const _AmenitiesHero(),

                const SizedBox(height: 60),

                // Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const _SectionHeader(
                        title: 'Resort Amenities',
                        subtitle:
                            'Indulge in our world-class facilities designed for your ultimate relaxation and enjoyment.',
                      ),
                      const SizedBox(height: 64),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 32,
                        mainAxisSpacing: 32,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          _AmenityCard(
                            title: 'Infinity Pool',
                            description:
                                'Our signature sunset pool with panoramic ocean views and curated poolside service.',
                            icon: Icons.pool,
                            imagePath: 'assets/images/luxury_pool.png',
                          ),
                          _AmenityCard(
                            title: 'Luxury Spa',
                            description:
                                'Holistic treatments and traditional therapies in a serene, multi-award winning environment.',
                            icon: Icons.spa,
                            imagePath:
                                'assets/images/luxury_pool.png', // Reusing for now
                          ),
                          _AmenityCard(
                            title: 'Oceanfront Dining',
                            description:
                                'A culinary journey featuring local ingredients and international fine dining.',
                            icon: Icons.restaurant,
                            imagePath:
                                'assets/images/luxury_pool.png', // Reusing for now
                          ),
                          _AmenityCard(
                            title: 'Fitness Suite',
                            description:
                                'State-of-the-art weights and cardio equipment with private training available.',
                            icon: Icons.fitness_center,
                            imagePath:
                                'assets/images/luxury_pool.png', // Reusing for now
                          ),
                          _AmenityCard(
                            title: 'Private Beach',
                            description:
                                'Exclusive access to our secluded cove with beach attendants and watersports.',
                            icon: Icons.beach_access,
                            imagePath:
                                'assets/images/luxury_pool.png', // Reusing for now
                          ),
                          _AmenityCard(
                            title: 'Concierge Service',
                            description:
                                'Our dedicated team is here to fulfill every request, 24 hours a day.',
                            icon: Icons.room_service,
                            imagePath:
                                'assets/images/luxury_pool.png', // Reusing for now
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
                const FooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesHero extends StatelessWidget {
  const _AmenitiesHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/luxury_pool.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WORLD-CLASS AMENITIES',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 4,
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'The Art of Relaxation',
              style: TextStyle(
                fontSize: 42,
                color: AppColors.cream,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            color: AppColors.cream,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 60,
          height: 3,
          color: AppColors.goldAccent,
        ),
      ],
    );
  }
}

class _AmenityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String imagePath;

  const _AmenityCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 24, color: AppColors.goldAccent),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.cream,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
