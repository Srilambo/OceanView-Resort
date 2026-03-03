import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../home/widgets/header_widget.dart';
import '../../home/widgets/footer_widget.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

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
                const _OffersHero(),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const _SectionHeader(
                        title: 'Exclusive Packages',
                        subtitle:
                            'Enhance your stay with our curated selection of special offers and seasonal packages.',
                      ),
                      const SizedBox(height: 64),
                      const _OfferCard(
                        title: 'Summer Sanctuary',
                        description:
                            'Book 5 nights or more and receive 20% off all spa treatments and a complimentary sunset dinner.',
                        discount: '20%',
                        imagePath: 'assets/images/luxury_pool.png',
                      ),
                      const SizedBox(height: 32),
                      const _OfferCard(
                        title: 'Honeymoon Bliss',
                        description:
                            'A romantic escape featuring champagne on arrival, a couples massage, and a private beach breakfast.',
                        discount: 'Special',
                        isReversed: true,
                        imagePath: 'assets/images/luxury_room.png',
                      ),
                      const SizedBox(height: 32),
                      const _OfferCard(
                        title: 'Early Bird Exclusive',
                        description:
                            'Plan your getaway at least 60 days in advance and receive an exclusive 15% discount on your entire stay.',
                        discount: '15%',
                        imagePath: 'assets/images/luxury_pool.png',
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

class _OffersHero extends StatelessWidget {
  const _OffersHero();

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
              'SPECIAL OFFERS',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 4,
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Exclusivity Awaits You',
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

class _OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String discount;
  final String imagePath;
  final bool isReversed;

  const _OfferCard({
    required this.title,
    required this.description,
    required this.discount,
    required this.imagePath,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    var content = [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 24,
                left: isReversed ? null : 24,
                right: isReversed ? 24 : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    discount,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 48),
      Expanded(
        child: Column(
          crossAxisAlignment:
              isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                color: AppColors.cream,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: isReversed ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.goldAccent,
                side: const BorderSide(color: AppColors.goldAccent),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('VIEW OFFER',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ];

    return Row(
      children: isReversed ? content.reversed.toList() : content,
    );
  }
}
