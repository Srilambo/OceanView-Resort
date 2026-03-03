import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../widgets/header_widget.dart';
import '../widgets/hero_section_widget.dart';
import '../widgets/booking_card_widget.dart';
import '../widgets/features_widget.dart';
import '../widgets/room_types_widget.dart';
import '../widgets/amenities_grid_widget.dart';
import '../widgets/testimonials_widget.dart';
import '../widgets/stats_widget.dart';
import '../widgets/cta_section_widget.dart';
import '../widgets/footer_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _bounceController;
  bool _showTopButton = false;
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      if (mounted) {
        setState(() {
          _showTopButton = _scrollController.offset > 300;
          _scrollProgress = (_scrollController.offset / 500).clamp(0, 1);
        });
      }
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Dynamic background pattern
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.5,
                  child: CustomPaint(
                    painter: BackgroundPainter(_bounceController.value),
                  ),
                );
              },
            ),
          ),

          // Background decorative elements
          _buildBackgroundDecor(),

          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeaderWidget(fadeAnimation: _fadeController),
                HeroSectionWidget(
                  fadeAnimation: _fadeController,
                  scrollProgress: _scrollProgress,
                ),
                const BookingCardWidget(),
                const FeaturesWidget(),
                const RoomTypesWidget(),
                const AmenitiesGridWidget(),
                const TestimonialsWidget(),
                const StatsWidget(),
                const CtaSectionWidget(),
                const FooterWidget(),
              ],
            ),
          ),

          if (_showTopButton) _buildBackToTopButton(),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
                decoration: const BoxDecoration(color: Colors.transparent)),
            Positioned(
              top: -150 + (_bounceController.value * 30),
              right: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldAccent.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -150 - (_bounceController.value * 20),
              left: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sageGreen.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackToTopButton() {
    return Positioned(
      bottom: 40,
      right: 40,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.goldAccent.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastOutSlowIn,
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.keyboard_arrow_up, color: AppColors.darkBg),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;
  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldAccent.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final offset = animationValue * 40;
      canvas.drawCircle(
        Offset(size.width * 0.1 + (i * 150) + offset, size.height * 0.5),
        100 + (animationValue * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
