import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../models/review.dart';
import '../../../../services/api_service.dart';

class ReviewsView extends StatefulWidget {
  const ReviewsView({Key? key}) : super(key: key);

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView>
    with SingleTickerProviderStateMixin {
  late Future<List<Review>> _futureReviews;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _futureReviews = ApiService.getAllReviews();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading reviews: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final reviews = snapshot.data ?? [];

        if (reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No Reviews Yet',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        _animationController.forward();

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guest Reviews',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'See what other guests are saying about their stay',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final review = reviews[index];
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.5, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            (index / reviews.length) * 0.5,
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index / reviews.length) * 0.5,
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          ),
                        ),
                        child: _buildReviewCard(review),
                      ),
                    );
                  },
                  childCount: reviews.length,
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        );
      },
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1565C0),
                    child: Text(
                      review.guestName.isNotEmpty
                          ? review.guestName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.guestName,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D47A1),
                        ),
                      ),
                      Text(
                        'Stayed in: ${review.roomType}',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (review.stayDate != null)
                Text(
                  DateFormat('MMM yyyy')
                      .format(DateTime.parse(review.stayDate!)),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            review.title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
