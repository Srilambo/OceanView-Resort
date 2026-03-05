import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../home/widgets/header_widget.dart';
import '../../home/widgets/footer_widget.dart';

class ExperiencesScreen extends StatelessWidget {
  const ExperiencesScreen({super.key});

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
                  AppColors.darkBgSecondary,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const _ExperiencesHero(),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const _SectionHeader(
                        title: 'Curated Experiences',
                        subtitle:
                            'From underwater exploration to private sunset dinners, we curate every detail of your stay.',
                      ),
                      const SizedBox(height: 64),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 32,
                        mainAxisSpacing: 32,
                        shrinkWrap: true,
                        childAspectRatio: 1.5,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          _ExperienceItem(
                            title: 'Sunset Cruise',
                            description:
                                'Set sail on our luxury yacht for a sunset journey with champagne and hors d\'oeuvres.',
                            imagePath: 'assets/images/luxury_pool.png',
                          ),
                          _ExperienceItem(
                            title: 'Private Beach Dinner',
                            description:
                                'An intimate, candlelit dinner on the beach under a canopy of stars.',
                            imagePath: 'assets/images/luxury_pool.png',
                          ),
                          _ExperienceItem(
                            title: 'Guided Reef Tour',
                            description:
                                'Discover the vibrant world beneath the surface with our expert guides.',
                            imagePath: 'assets/images/luxury_pool.png',
                          ),
                          _ExperienceItem(
                            title: 'Yoga & Meditation',
                            description:
                                'Restore your balance with morning yoga sessions on our oceanfront pavilion.',
                            imagePath: 'assets/images/luxury_pool.png',
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

class _ExperiencesHero extends StatelessWidget {
  const _ExperiencesHero();

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
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CURATED MOMENTS',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 4,
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Experience Wonders',
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

class _ExperienceItem extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const _ExperienceItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.cream,
                      fontWeight: FontWeight.bold,
                    ),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('EXPLORE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

