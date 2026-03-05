import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';

class CheckInView extends StatefulWidget {
  const CheckInView({super.key});

  @override
  State<CheckInView> createState() => _CheckInViewState();
}

class _CheckInViewState extends State<CheckInView> {
  late Future<List<Reservation>> _futureReservations;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() {
    setState(() {
      _futureReservations = ApiService.getAllReservations().then(
          (list) => list.where((res) => res.status == 'CONFIRMED').toList());
    });
  }

  Future<void> _handleCheckIn(String id) async {
    try {
      await ApiService.checkIn(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Checked in successfully!'),
            backgroundColor: Colors.green),
      );
      _loadReservations();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
          Text(
            'Guest Check-in',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Process check-ins for arriving guests',
            style: GoogleFonts.montserrat(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<Reservation>>(
              future: _futureReservations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final reservations = snapshot.data ?? [];
                if (reservations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No pending check-ins for today.',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey.shade500)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final res = reservations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF1565C0).withOpacity(0.1),
                          child: const Icon(Icons.person,
                              color: Color(0xFF1565C0)),
                        ),
                        title: Text(
                          res.guestName,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Room: ${res.roomNumber} (${res.roomType})'),
                            Text('Booking: #${res.reservationNumber}'),
                            Text(
                                'Dates: ${res.checkInDate.toString().split(' ')[0]} to ${res.checkOutDate.toString().split(' ')[0]}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _handleCheckIn(res.reservationId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Check-in'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
