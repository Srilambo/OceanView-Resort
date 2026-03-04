import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../home/widgets/header_widget.dart';
import '../../home/widgets/footer_widget.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Background gradient
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

                // Hero Section for Rooms
                const _RoomsHero(),

                const SizedBox(height: 60),

                // Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                        title: 'Our Signature Rooms',
                        subtitle:
                            'Experience ultimate comfort and breathtaking views in our meticulously designed accommodations.',
                      ),
                      const SizedBox(height: 48),
                      const _RoomCard(
                        title: 'Ocean View Suite',
                        description:
                            'Wake up to the sound of waves in our premier suite featuring a private balcony and panoramic ocean views.',
                        price: '450',
                        imagePath: 'assets/images/luxury_room.png',
                      ),
                      const SizedBox(height: 32),
                      const _RoomCard(
                        title: 'Garden Deluxe',
                        description:
                            'A serene escape surrounded by lush tropical greenery, perfect for those seeking tranquility.',
                        price: '320',
                        isReversed: true,
                        imagePath:
                            'assets/images/luxury_room.png', // Reusing for now
                      ),
                      const SizedBox(height: 32),
                      const _RoomCard(
                        title: 'Presidential Villa',
                        description:
                            'The pinnacle of luxury. Private pool, butler service, and the most expansive views in the resort.',
                        price: '1,200',
                        imagePath:
                            'assets/images/luxury_room.png', // Reusing for now
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

class _RoomsHero extends StatelessWidget {
  const _RoomsHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/luxury_room.png'),
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
              'LUXURY ROOMS',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 4,
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'A Sanctuary of Style & Comfort',
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
      crossAxisAlignment: CrossAxisAlignment.start,
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

class _RoomCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imagePath;
  final bool isReversed;

  const _RoomCard({
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    var content = [
      Expanded(
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
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
                fontSize: 24,
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment:
                  isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.goldAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' / night',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.goldAccent,
                side: const BorderSide(color: AppColors.goldAccent),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('VIEW DETAILS'),
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

