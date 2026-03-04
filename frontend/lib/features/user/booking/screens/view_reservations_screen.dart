import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';
import '../../../../theme/app_colors.dart';
import 'bill_screen.dart';

class ViewReservationsScreen extends StatefulWidget {
  final String guestId;

  const ViewReservationsScreen({super.key, required this.guestId});

  @override
  State<ViewReservationsScreen> createState() => _ViewReservationsScreenState();
}

class _ViewReservationsScreenState extends State<ViewReservationsScreen>
    with TickerProviderStateMixin {
  List<Reservation> _reservations = [];
  bool _isLoading = true;
  String? _errorMessage;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bounceController.repeat(reverse: true);
    });
    _loadReservations();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reservations = await ApiService.getGuestReservations(
        widget.guestId,
      );
      setState(() {
        _reservations = reservations;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'MY RESERVATIONS',
          style: TextStyle(
            color: AppColors.goldAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new, color: AppColors.goldAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.3,
                  child: CustomPaint(
                    painter: BackgroundPainter(_bounceController.value),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.goldAccent),
                  )
                : RefreshIndicator(
                    onRefresh: _loadReservations,
                    color: AppColors.goldAccent,
                    backgroundColor: AppColors.darkBgSecondary,
                    child: _errorMessage != null
                        ? _buildErrorPlaceholder()
                        : _reservations.isEmpty
                            ? _buildEmptyPlaceholder()
                            : _buildReservationsList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.redAccent.shade100),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: const TextStyle(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadReservations,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldAccent,
              foregroundColor: AppColors.darkBg,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 64, color: AppColors.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No reservations found',
            style: TextStyle(color: AppColors.textMuted, fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldAccent,
              foregroundColor: AppColors.darkBg,
            ),
            child: const Text('Explore Rooms'),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _reservations.length,
      itemBuilder: (context, index) {
        final reservation = _reservations[index];
        return _buildReservationCard(reservation);
      },
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    final statusColor = _getStatusColor(reservation.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.darkBgSecondary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RESERVATION',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          reservation.reservationNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        reservation.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: AppColors.glassBorder, height: 1),
                ),
                _buildInfoRow(
                  Icons.hotel_outlined,
                  'Room ${reservation.roomNumber}',
                  'Guest: ${reservation.guestName}',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  '${DateFormat('MMM dd').format(reservation.checkInDate)} - ${DateFormat('MMM dd, yyyy').format(reservation.checkOutDate)}',
                  'Duration: ${_calculateNights(reservation.checkInDate, reservation.checkOutDate)} nights',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.payments_outlined,
                  '\$${reservation.totalCost.toStringAsFixed(2)}',
                  'Total Cost',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.receipt_long_outlined,
                        label: 'View Bill',
                        color: AppColors.goldAccent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BillScreen(
                                reservationId: reservation.reservationId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (reservation.status != 'CANCELLED') ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.close_rounded,
                          label: 'Cancel',
                          color: Colors.redAccent.shade100,
                          onTap: () =>
                              _cancelReservation(reservation.reservationId),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.goldAccent, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateNights(DateTime checkIn, DateTime checkOut) {
    return checkOut.difference(checkIn).inDays;
  }

  Future<void> _cancelReservation(String reservationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: AppColors.darkBgSecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Cancel Reservation',
              style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to cancel this reservation? This action cannot be undone.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No, Keep it',
                  style: TextStyle(color: AppColors.textLight)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, Cancel',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.cancelReservation(reservationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reservation cancelled successfully'),
              backgroundColor: AppColors.sageGreen,
            ),
          );
          _loadReservations();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orangeAccent;
      case 'CONFIRMED':
        return AppColors.sageGreen;
      case 'CANCELLED':
        return Colors.redAccent.shade100;
      case 'CHECKED_IN':
        return Colors.blueAccent.shade100;
      default:
        return AppColors.textMuted;
    }
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;
  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.02)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final offset = animationValue * 40;
      canvas.drawCircle(
        Offset(size.width * 0.8 - (i * 200) - offset, size.height * 0.2),
        150 + (animationValue * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
