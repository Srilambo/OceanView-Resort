import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reservation.dart';
import '../models/room.dart';
import '../services/api_service.dart';

class NewReservationScreen extends StatefulWidget {
  final String userId;

  const NewReservationScreen({super.key, required this.userId});

  @override
  State<NewReservationScreen> createState() => _NewReservationScreenState();
}

class _NewReservationScreenState extends State<NewReservationScreen> {
  final _specialRequestsController = TextEditingController();
  DateTime? _selectedCheckInDate;
  DateTime? _selectedCheckOutDate;
  Room? _selectedRoom;
  List<Room> _availableRooms = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAvailableRooms();
  }

  Future<void> _loadAvailableRooms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rooms = await ApiService.getAvailableRooms();
      setState(() {
        _availableRooms = rooms;
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

  Future<void> _selectCheckInDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedCheckInDate = picked);
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (_selectedCheckInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in date first')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedCheckInDate!.add(const Duration(days: 1)),
      firstDate: _selectedCheckInDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedCheckOutDate = picked);
    }
  }

  Future<void> _createReservation() async {
    if (_selectedCheckInDate == null ||
        _selectedCheckOutDate == null ||
        _selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Reservation reservation = await ApiService.createReservation(
        guestId: widget.userId,
        roomId: _selectedRoom!.roomId,
        checkInDate: _selectedCheckInDate!,
        checkOutDate: _selectedCheckOutDate!,
        specialRequests: _specialRequestsController.text.isNotEmpty
            ? _specialRequestsController.text
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservation created successfully!')),
        );
        Navigator.of(context).pop(reservation);
      }
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
      appBar: AppBar(
        title: const Text('New Reservation'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: _isLoading && _availableRooms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Check-in Date',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectCheckInDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(
                            _selectedCheckInDate != null
                                ? DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(_selectedCheckInDate!)
                                : 'Select date',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Check-out Date',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectCheckOutDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(
                            _selectedCheckOutDate != null
                                ? DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(_selectedCheckOutDate!)
                                : 'Select date',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Room',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _availableRooms.isEmpty
                      ? const Text('No available rooms')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _availableRooms.length,
                          itemBuilder: (context, index) {
                            final room = _availableRooms[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                selected: _selectedRoom?.roomId == room.roomId,
                                selectedTileColor: Colors.blue.shade100,
                                title: Text('Room ${room.roomNumber}'),
                                subtitle: Text(
                                  '${room.roomType} - \$${room.pricePerNight.toStringAsFixed(2)}/night',
                                ),
                                trailing: _selectedRoom?.roomId == room.roomId
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                                onTap: () {
                                  setState(() => _selectedRoom = room);
                                },
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                  Text(
                    'Special Requests (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _specialRequestsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter any special requests...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Create Reservation',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }
}
