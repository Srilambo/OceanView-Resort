import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/room.dart';
import '../../../../services/api_service.dart';

class RoomStatusView extends StatefulWidget {
  const RoomStatusView({super.key});

  @override
  State<RoomStatusView> createState() => _RoomStatusViewState();
}

class _RoomStatusViewState extends State<RoomStatusView> {
  List<Room> _rooms = [];
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rooms = await ApiService.getAllRooms();
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateRoomStatus(Room room, String newStatus) async {
    try {
      // Logic for backend update: if status is AVAILABLE, then available is true.
      // Else, available is false.
      bool isAvailable = newStatus == 'AVAILABLE';

      final updatedRoom = Room(
        roomId: room.roomId,
        roomNumber: room.roomNumber,
        roomType: room.roomType,
        capacity: room.capacity,
        pricePerNight: room.pricePerNight,
        description: room.description,
        available: isAvailable,
        status: newStatus,
      );

      await ApiService.updateRoom(updatedRoom);
      _loadRooms(); // Refresh the list

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Room ${room.roomNumber} updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update room: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Room> filteredRooms = _rooms;
    if (_selectedFilter != 'All') {
      filteredRooms = _rooms.where((r) => r.status == _selectedFilter).toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
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
                    'Room Status Management',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monitor and update cleaning and occupancy status',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _loadRooms,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Filters
          _buildFilters(),
          const SizedBox(height: 24),

          if (_isLoading)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(100),
                    child: CircularProgressIndicator()))
          else if (_error != null)
            _buildErrorState()
          else if (filteredRooms.isEmpty)
            _buildEmptyState()
          else
            _buildRoomGrid(filteredRooms),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final statuses = [
      'All',
      'AVAILABLE',
      'OCCUPIED',
      'CLEANING',
      'MAINTENANCE'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          final isSelected = _selectedFilter == status;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = status);
              },
              selectedColor: const Color(0xFF1565C0),
              labelStyle: GoogleFonts.montserrat(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getRoomImage(String type) {
    final t = type.trim().toUpperCase();
    if (t.contains('DELUXE')) {
      return 'assets/images/room2_garden_deluxe_img2.png';
    } else if (t.contains('SUITE')) {
      return 'assets/images/room1_ocean_suite_img2.png';
    } else if (t.contains('VILLA')) {
      return 'assets/images/room3_presidential_suite_img1.png';
    } else {
      return 'assets/images/luxury_room.png';
    }
  }

  Widget _buildRoomGrid(List<Room> rooms) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 0.9,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return _buildRoomCard(rooms[index]);
      },
    );
  }

  Widget _buildRoomCard(Room room) {
    Color statusColor;
    IconData statusIcon;

    switch (room.status) {
      case 'AVAILABLE':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'OCCUPIED':
        statusColor = Colors.blue;
        statusIcon = Icons.person;
        break;
      case 'CLEANING':
        statusColor = Colors.orange;
        statusIcon = Icons.cleaning_services;
        break;
      case 'MAINTENANCE':
        statusColor = Colors.red;
        statusIcon = Icons.build;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image Header
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getRoomImage(room.roomType)),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Room ${room.roomNumber}',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: statusColor.withOpacity(0.4),
                                blurRadius: 8)
                          ],
                        ),
                        child: Icon(statusIcon, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  Text(
                    room.roomType.toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_outline,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Capacity: ${room.capacity}',
                      style: GoogleFonts.montserrat(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Update Status:',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusActionButton(room, 'AVAILABLE', Colors.green),
                    _statusActionButton(room, 'OCCUPIED', Colors.blue),
                    _statusActionButton(room, 'CLEANING', Colors.orange),
                    _statusActionButton(room, 'MAINTENANCE', Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusActionButton(Room room, String status, Color color) {
    bool isCurrent = room.status == status;
    return InkWell(
      onTap: isCurrent ? null : () => _updateRoomStatus(room, status),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrent ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(
          _getStatusIcon(status),
          size: 18,
          color: isCurrent ? Colors.white : color,
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'AVAILABLE':
        return Icons.check;
      case 'OCCUPIED':
        return Icons.person;
      case 'CLEANING':
        return Icons.cleaning_services;
      case 'MAINTENANCE':
        return Icons.build;
      default:
        return Icons.help;
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(_error!),
          ElevatedButton(onPressed: _loadRooms, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.hotel_class, color: Colors.grey, size: 48),
          SizedBox(height: 16),
          Text('No rooms found matching the filter.'),
        ],
      ),
    );
  }
}
