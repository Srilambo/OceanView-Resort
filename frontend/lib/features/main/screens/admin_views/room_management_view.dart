import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/room.dart';
import '../../../../services/api_service.dart';

class RoomManagementView extends StatefulWidget {
  const RoomManagementView({super.key});

  @override
  State<RoomManagementView> createState() => _RoomManagementViewState();
}

class _RoomManagementViewState extends State<RoomManagementView> {
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = ApiService.getAllRooms();
  }

  void _refresh() {
    setState(() {
      _roomsFuture = ApiService.getAllRooms();
    });
  }

  Future<void> _deleteRoom(String roomId) async {
    try {
      await ApiService.deleteRoom(roomId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room deleted successfully')),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting room: $e')),
      );
    }
  }

  void _showAddRoomDialog() {
    final numberController = TextEditingController();
    final typeController = TextEditingController();
    final capacityController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Room', style: GoogleFonts.playfairDisplay()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Room Number'),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                    labelText: 'Room Type (e.g. DELUXE, STANDARD)'),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price Per Night'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'https://images.unsplash.com/...'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final room = Room(
                  roomId: '', // Backend will generate UUID
                  roomNumber: numberController.text,
                  roomType: typeController.text,
                  capacity: int.parse(capacityController.text),
                  pricePerNight: double.parse(priceController.text),
                  description: descController.text,
                  imageUrl: imageController.text.isNotEmpty
                      ? imageController.text
                      : null,
                  available: true,
                  status: 'AVAILABLE',
                );
                await ApiService.createRoom(room);
                if (!mounted) return;
                Navigator.pop(context);
                _refresh();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _getRoomImage(String type) {
    final t = type.trim().toUpperCase();
    if (t.contains('DELUXE')) {
      return 'assets/images/room2_garden_deluxe_img1.png';
    } else if (t.contains('SUITE')) {
      return 'assets/images/room1_ocean_suite_img1.png';
    } else if (t.contains('VILLA')) {
      return 'assets/images/room3_presidential_suite_img1.png';
    } else {
      return 'assets/images/luxury_room.png';
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
                'Room Management',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddRoomDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Room'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009688),
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
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8),
                ],
              ),
              child: FutureBuilder<List<Room>>(
                future: _roomsFuture,
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
                          Text('Error loading rooms: ${snapshot.error}',
                              style: GoogleFonts.montserrat(color: Colors.red)),
                          TextButton(
                              onPressed: _refresh, child: const Text('Retry')),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No rooms found.',
                          style: GoogleFonts.montserrat(color: Colors.grey)),
                    );
                  }

                  final roomList = snapshot.data!;
                  return ListView.separated(
                    itemCount: roomList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final room = roomList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color:
                                const Color(0xFF009688).withValues(alpha: 0.1),
                            child: room.imageUrl != null &&
                                    room.imageUrl!.isNotEmpty
                                ? Image.network(
                                    room.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      _getRoomImage(room.roomType),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    _getRoomImage(room.roomType),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        title: Text(
                          room.roomType,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D47A1)),
                        ),
                        subtitle: Text(
                          'Room ${room.roomNumber} • Max ${room.capacity} Guests',
                          style: GoogleFonts.montserrat(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${room.pricePerNight.toStringAsFixed(2)}',
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
                                color: room.available
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                room.available ? 'Available' : 'Occupied',
                                style: GoogleFonts.montserrat(
                                  color: room.available
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue, size: 20),
                                onPressed: () {
                                  // Implementation for edit could go here
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                onPressed: () => _deleteRoom(room.roomId)),
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
