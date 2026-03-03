import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1: Contact
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT US',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFooterInfo(
                        Icons.location_on, 'Galle Road, Bentota\nSri Lanka'),
                    const SizedBox(height: 16),
                    _buildFooterInfo(Icons.phone, '+94 91 123 4567'),
                    const SizedBox(height: 16),
                    _buildFooterInfo(Icons.email, 'info@oceanview.com'),
                  ],
                ),
              ),
              // Column 2: Quick Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterTitle('QUICK LINKS'),
                    _buildFooterLink('Rooms'),
                    _buildFooterLink('Amenities'),
                    _buildFooterLink('Experiences'),
                    _buildFooterLink('Special Offers'),
                  ],
                ),
              ),
              // Column 3: Social
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterTitle('SOCIAL'),
                    _buildFooterLink('Instagram'),
                    _buildFooterLink('Facebook'),
                    _buildFooterLink('Twitter'),
                    _buildFooterLink('LinkedIn'),
                  ],
                ),
              ),
              // Column 4: Newsletter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterTitle('NEWSLETTER'),
                    Text(
                      'Subscribe to receive latest news and exclusive offers.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textLight.withValues(alpha: 0.6),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNewsletterField(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '(c) 2025 OCEAN VIEW RESORT. ALL RIGHTS RESERVED.',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textLight.withValues(alpha: 0.4),
                  letterSpacing: 1,
                ),
              ),
              Row(
                children: [
                  _buildSocialIcon(Icons.facebook),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.camera_alt),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.alternate_email),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.goldAccent,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFooterLink(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textLight.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16, color: AppColors.goldAccent.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textLight.withValues(alpha: 0.6),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Icon(
        icon,
        size: 18,
        color: AppColors.textLight.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildNewsletterField() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Your email address',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'SEND',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
