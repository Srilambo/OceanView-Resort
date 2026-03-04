import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';

class BookingManagementView extends StatefulWidget {
  const BookingManagementView({Key? key}) : super(key: key);

  @override
  State<BookingManagementView> createState() => _BookingManagementViewState();
}

class _BookingManagementViewState extends State<BookingManagementView> {
  late Future<List<Reservation>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = ApiService.getAllReservations();
  }

  void _refresh() {
    setState(() {
      _bookingsFuture = ApiService.getAllReservations();
    });
  }

  Future<void> _cancelBooking(String reservationId) async {
    try {
      await ApiService.cancelReservation(reservationId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled successfully')),
      );
      _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling booking: $e')),
      );
    }
  }

  Future<void> _updateStatus(String reservationId, String status) async {
    try {
      await ApiService.updateReservationStatus(reservationId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking status updated to $status')),
      );
      _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Management',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF57C00),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 8),
                ],
              ),
              child: FutureBuilder<List<Reservation>>(
                future: _bookingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade300, size: 48),
                          const SizedBox(height: 16),
                          Text('Error loading bookings: ${snapshot.error}',
                              style: GoogleFonts.montserrat(color: Colors.red)),
                          TextButton(
                              onPressed: _refresh, child: const Text('Retry')),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No bookings found.',
                          style: GoogleFonts.montserrat(color: Colors.grey)),
                    );
                  }

                  final bookingList = snapshot.data!;
                  return ListView.separated(
                    itemCount: bookingList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final booking = bookingList[index];
                      // Format dates
                      final checkInStr =
                          '${booking.checkInDate.year}-${booking.checkInDate.month.toString().padLeft(2, '0')}-${booking.checkInDate.day.toString().padLeft(2, '0')}';
                      final checkOutStr =
                          '${booking.checkOutDate.year}-${booking.checkOutDate.month.toString().padLeft(2, '0')}-${booking.checkOutDate.day.toString().padLeft(2, '0')}';

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF57C00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.event_note,
                              color: Color(0xFFF57C00)),
                        ),
                        title: Text(
                          booking.guestName.isNotEmpty
                              ? booking.guestName
                              : 'Guest ${booking.guestId}',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D47A1)),
                        ),
                        subtitle: Text(
                          'Booking #${booking.reservationNumber} • Room ${booking.roomNumber.isNotEmpty ? booking.roomNumber : booking.roomId}\n$checkInStr to $checkOutStr',
                          style: GoogleFonts.montserrat(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${booking.totalCost.toStringAsFixed(2)}',
                              style: GoogleFonts.playfairDisplay(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: booking.status == 'CONFIRMED'
                                    ? Colors.green.withOpacity(0.1)
                                    : booking.status == 'PENDING'
                                        ? Colors.orange.withOpacity(0.1)
                                        : booking.status == 'CANCELLED'
                                            ? Colors.red.withOpacity(0.1)
                                            : Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status,
                                style: GoogleFonts.montserrat(
                                  color: booking.status == 'CONFIRMED'
                                      ? Colors.green
                                      : booking.status == 'PENDING'
                                          ? Colors.orange
                                          : booking.status == 'CANCELLED'
                                              ? Colors.red
                                              : Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                                tooltip: 'Confirm Booking',
                                onPressed: () => _updateStatus(
                                    booking.reservationId, 'CONFIRMED')),
                            IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red, size: 20),
                                tooltip: 'Cancel Booking',
                                onPressed: () =>
                                    _cancelBooking(booking.reservationId)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
