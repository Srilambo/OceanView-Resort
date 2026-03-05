import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';

class RoomTypesWidget extends StatelessWidget {
  const RoomTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
      child: Column(
        children: [
          Text(
            'ROOM CATEGORIES',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.cream,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 60),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            children: const [
              _GlassRoomCard(
                title: 'SINGLE',
                price: '\$100',
                capacity: '1 Person',
                icon: Icons.person,
                imagePath: 'assets/images/resort_hero.png',
              ),
              _GlassRoomCard(
                title: 'DOUBLE',
                price: '\$150',
                capacity: '2 Persons',
                icon: Icons.people,
                imagePath: 'assets/images/luxury_room.png',
              ),
              _GlassRoomCard(
                title: 'DELUXE',
                price: '\$200',
                capacity: '2 Persons',
                icon: Icons.star,
                imagePath: 'assets/images/room2_garden_deluxe_img1.png',
              ),
              _GlassRoomCard(
                title: 'SUITE',
                price: '\$250',
                capacity: '4 Persons',
                icon: Icons.apartment,
                imagePath: 'assets/images/room1_ocean_suite_img1.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassRoomCard extends StatefulWidget {
  final String title;
  final String price;
  final String capacity;
  final IconData icon;
  final String imagePath;

  const _GlassRoomCard({
    required this.title,
    required this.price,
    required this.capacity,
    required this.icon,
    required this.imagePath,
  });

  @override
  State<_GlassRoomCard> createState() => _GlassRoomCardState();
}

class _GlassRoomCardState extends State<_GlassRoomCard> {
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldAccent
                : Colors.white.withOpacity(0.12),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.goldAccent.withOpacity(0.2),
                    blurRadius: 24,
                  )
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF1A1A2E), // Deep dark fallback
                    child: Center(
                      child: Icon(
                        widget.icon,
                        size: 60,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Glass/Dark Overlay
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: _isHovered
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black.withOpacity(0.6),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: 40, color: AppColors.goldAccent),
                  const SizedBox(height: 24),
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cream,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.price}/night',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.goldAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.capacity,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight.withOpacity(0.8),
                    ),
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
