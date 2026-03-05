import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';
import '../../../authentication/providers/auth_provider.dart';
import 'bill_screen.dart';

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({Key? key}) : super(key: key);

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView>
    with SingleTickerProviderStateMixin {
  late Future<List<Reservation>> _futureReservations;
  late AnimationController _animationController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _initData();
  }

  Future<void> _initData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null) {
        final guest = await ApiService.getGuestByUserId(user.id);
        if (mounted) {
          setState(() {
            _futureReservations =
                ApiService.getGuestReservations(guest.guestId);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Reservation>>(
      future: _futureReservations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading bookings',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: GoogleFonts.montserrat(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => setState(() => _initData()),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No Bookings Found',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have no upcoming or past reservations.',
                  style: GoogleFonts.montserrat(color: Colors.grey.shade500),
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
                      'My Bookings',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your upcoming and past stays',
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
                    final booking = bookings[index];
                    final isUpcoming =
                        booking.checkInDate.isAfter(DateTime.now());

                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            (index / bookings.length) * 0.5,
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
                              (index / bookings.length) * 0.5,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                        child: _buildBookingCard(booking, isUpcoming),
                      ),
                    );
                  },
                  childCount: bookings.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingCard(Reservation booking, bool isUpcoming) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'CONFIRMED':
          return Colors.green;
        case 'CHECKED_IN':
          return const Color(0xFF1565C0);
        case 'PENDING':
          return Colors.orange;
        case 'COMPLETED':
          return Colors.blue;
        case 'CANCELLED':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 120,
                height: 140,
                color: (booking.status == 'CHECKED_IN' || isUpcoming)
                    ? const Color(0xFF1565C0)
                    : Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (booking.status == 'CHECKED_IN' || isUpcoming)
                          ? Icons.hotel
                          : Icons.history,
                      size: 40,
                      color: (booking.status == 'CHECKED_IN' || isUpcoming)
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('MMM d').format(booking.checkInDate),
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (booking.status == 'CHECKED_IN' || isUpcoming)
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      booking.checkInDate.year.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: (booking.status == 'CHECKED_IN' || isUpcoming)
                            ? Colors.white70
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Room ${booking.roomNumber}',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D47A1),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor(booking.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking.status,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: getStatusColor(booking.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Res Number: ${booking.reservationNumber}',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.nightlight_round,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.numberOfNights} Nights',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('MMM d').format(booking.checkInDate)} - ${DateFormat('MMM d').format(booking.checkOutDate)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Cost:',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '\$${booking.totalCost.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF57C00),
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BillScreen(
                                    reservationId: booking.reservationId,
                                    reservationNumber:
                                        booking.reservationNumber,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.receipt_long_rounded,
                                size: 16),
                            label: Text(
                              'View Bill',
                              style: GoogleFonts.montserrat(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D47A1),
                              side: const BorderSide(color: Color(0xFF0D47A1)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Upcoming marker
          if (booking.status == 'CHECKED_IN')
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'ACTIVE STAY',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else if (isUpcoming)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFF57C00),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'UPCOMING',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
