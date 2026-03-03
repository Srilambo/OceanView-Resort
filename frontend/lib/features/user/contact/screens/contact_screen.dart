import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../home/widgets/header_widget.dart';
import '../../home/widgets/footer_widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
                const _ContactHero(),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const _SectionHeader(
                        title: 'Get in Touch',
                        subtitle:
                            'Our dedicated team is always here to assist you with any questions or requests.',
                      ),
                      const SizedBox(height: 64),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _ContactDetails(),
                          ),
                          const SizedBox(width: 80),
                          Expanded(
                            flex: 2,
                            child: _ContactForm(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _MapSection(),
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

class _ContactHero extends StatelessWidget {
  const _ContactHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
              'assets/images/luxury_pool.png'), // Using pool for now
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
              'REACH OUT',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 4,
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your Journey Starts Here',
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

class _ContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailItem(
            icon: Icons.location_on,
            title: 'Our Location',
            detail: 'Ocean View Road, Bliss Bay,\nTropical Coast, 12345'),
        SizedBox(height: 40),
        _DetailItem(
            icon: Icons.phone,
            title: 'Reservations',
            detail: '+1 (800) OCEAN-VW\n+1 (555) 123-4567'),
        SizedBox(height: 40),
        _DetailItem(
            icon: Icons.email,
            title: 'Email Address',
            detail: 'reservations@oceanview.com\nexperiences@oceanview.com'),
        SizedBox(height: 40),
        _DetailItem(
            icon: Icons.access_time,
            title: 'Reception Hours',
            detail: 'Every Day\n24 Hours'),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  const _DetailItem(
      {required this.icon, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 28, color: AppColors.goldAccent),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.cream,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SEND US A MESSAGE',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 2,
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(child: _InputField(label: 'Full Name')),
              SizedBox(width: 24),
              Expanded(child: _InputField(label: 'Email Address')),
            ],
          ),
          const SizedBox(height: 24),
          const _InputField(label: 'Subject'),
          const SizedBox(height: 24),
          const _InputField(
              label: 'Special Requirements / Message', maxLines: 5),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldAccent,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('SEND MESSAGE',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final int maxLines;
  const _InputField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.cream),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.darkBg.withValues(alpha: 0.3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.goldAccent),
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }
}

class _MapSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 100),
      decoration: const BoxDecoration(
        color: AppColors.darkBgSecondary,
      ),
      child: const Stack(
        children: [
          // Placeholder for map integration
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: AppColors.textMuted),
                SizedBox(height: 24),
                Text(
                  'INTERACTIVE MAP PLACEMENT',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    letterSpacing: 2,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Gradient overlays for map
        ],
      ),
    );
  }
}
