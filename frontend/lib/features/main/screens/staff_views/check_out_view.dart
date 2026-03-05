import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({Key? key}) : super(key: key);

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  late Future<List<Reservation>> _futureReservations;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() {
    setState(() {
      _futureReservations = ApiService.getAllReservations().then(
          (list) => list.where((res) => res.status == 'CHECKED_IN').toList());
    });
  }

  Future<void> _handleCheckOut(String id) async {
    try {
      await ApiService.checkOut(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Checked out successfully!'),
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
            'Guest Check-out',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Finalize check-out and billing for departing guests',
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
                        Icon(Icons.hotel,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No active stays to check-out.',
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
                          backgroundColor: Colors.red.withOpacity(0.1),
                          child: const Icon(Icons.logout, color: Colors.red),
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
                          onPressed: () => _handleCheckOut(res.reservationId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Check-out'),
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
