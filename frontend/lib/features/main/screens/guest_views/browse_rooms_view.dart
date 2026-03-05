import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/room.dart';
import '../../../../services/api_service.dart';

class BrowseRoomsView extends StatefulWidget {
  const BrowseRoomsView({Key? key}) : super(key: key);

  @override
  State<BrowseRoomsView> createState() => _BrowseRoomsViewState();
}

class _BrowseRoomsViewState extends State<BrowseRoomsView> {
  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'All';

  final List<String> _roomTypes = [
    'All',
    'STANDARD',
    'DELUXE',
    'SUITE',
    'VILLA',
    'PENTHOUSE',
  ];

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
        _allRooms = rooms;
        _filteredRooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String type) {
    setState(() {
      _selectedFilter = type;
      if (type == 'All') {
        _filteredRooms = _allRooms;
      } else {
        _filteredRooms =
            _allRooms.where((room) => room.roomType == type).toList();
      }
    });
  }

  Color _getRoomTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'STANDARD':
        return const Color(0xFF4CAF50);
      case 'DELUXE':
        return const Color(0xFF1565C0);
      case 'SUITE':
        return const Color(0xFFF57C00);
      case 'VILLA':
        return const Color(0xFF7B1FA2);
      case 'PENTHOUSE':
        return const Color(0xFFD4AF37);
      default:
        return const Color(0xFF607D8B);
    }
  }

  IconData _getRoomTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'STANDARD':
        return Icons.bed;
      case 'DELUXE':
        return Icons.king_bed;
      case 'SUITE':
        return Icons.villa;
      case 'VILLA':
        return Icons.home;
      case 'PENTHOUSE':
        return Icons.apartment;
      default:
        return Icons.hotel;
    }
  }

  String _getRoomImage(String type) {
    // All rooms use the same asset for now
    return 'assets/images/luxury_room.png';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadRooms,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Filter Chips
            _buildFilterChips(),
            const SizedBox(height: 24),

            // Content
            if (_isLoading)
              _buildLoadingState()
            else if (_error != null)
              _buildErrorState()
            else if (_filteredRooms.isEmpty)
              _buildEmptyState()
            else
              _buildRoomGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse Rooms',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover your perfect stay at Ocean View Resort',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_allRooms.length} Rooms Available',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.hotel, size: 48, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _roomTypes.map((type) {
          final isSelected = _selectedFilter == type;
          final color =
              type == 'All' ? const Color(0xFF1565C0) : _getRoomTypeColor(type);

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(
                type == 'All' ? 'All Rooms' : type,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : color,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => _applyFilter(type),
              backgroundColor: color.withOpacity(0.08),
              selectedColor: color,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? color : color.withOpacity(0.3),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF1565C0),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading rooms...',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to load rooms',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadRooms,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No rooms found',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing the filter to see more rooms.',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth > 1200) {
      crossAxisCount = 3;
    } else if (screenWidth > 800) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: screenWidth > 600 ? 0.75 : 0.85,
      ),
      itemCount: _filteredRooms.length,
      itemBuilder: (context, index) {
        return _buildRoomCard(_filteredRooms[index]);
      },
    );
  }

  Widget _buildRoomCard(Room room) {
    final typeColor = _getRoomTypeColor(room.roomType);
    final typeIcon = _getRoomTypeIcon(room.roomType);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image + Badge
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(_getRoomImage(room.roomType)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),

                // Room Type Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: typeColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(typeIcon, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          room.roomType,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Availability Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: room.available
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      room.available ? 'Available' : 'Booked',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Room Number
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Room ${room.roomNumber}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Room Details
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Name
                  Text(
                    '${room.roomType[0]}${room.roomType.substring(1).toLowerCase()} Room ${room.roomNumber}',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Expanded(
                    child: Text(
                      room.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Amenities Row
                  Row(
                    children: [
                      _buildAmenityChip(
                          Icons.people, '${room.capacity} Guests'),
                      const SizedBox(width: 8),
                      _buildAmenityChip(Icons.wifi, 'Wi-Fi'),
                      const SizedBox(width: 8),
                      _buildAmenityChip(Icons.ac_unit, 'AC'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price + Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${room.pricePerNight.toStringAsFixed(0)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF57C00),
                            ),
                          ),
                          Text(
                            'per night',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: room.available
                            ? () => _showRoomDetails(room)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: room.available
                              ? const Color(0xFF1565C0)
                              : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: room.available ? 2 : 0,
                        ),
                        child: Text(
                          room.available ? 'View Details' : 'Unavailable',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomDetails(Room room) {
    final typeColor = _getRoomTypeColor(room.roomType);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 500,
          constraints: const BoxConstraints(maxHeight: 650),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(_getRoomImage(room.roomType)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          room.roomType,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Room ${room.roomNumber}',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Description',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      room.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            Icons.people,
                            'Capacity',
                            '${room.capacity} Guests',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoTile(
                            Icons.attach_money,
                            'Price',
                            '\$${room.pricePerNight.toStringAsFixed(0)}/night',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            Icons.meeting_room,
                            'Room No.',
                            room.roomNumber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoTile(
                            room.available ? Icons.check_circle : Icons.cancel,
                            'Status',
                            room.available ? 'Available' : 'Booked',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Close',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed:
                                room.available ? () => _bookRoom(room) : null,
                            icon: const Icon(Icons.book_online, size: 18),
                            label: Text(
                              'Book Now',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1565C0)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bookRoom(Room room) async {
    Navigator.pop(context);

    final DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
            ),
          ),
          child: child!,
        );
      },
      helpText: 'Select Booking Dates',
    );

    if (dateRange != null) {
      try {
        await ApiService.createReservation(
          guestId: 'guest-sri-001',
          roomId: room.roomId,
          checkInDate: dateRange.start,
          checkOutDate: dateRange.end,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Room ${room.roomNumber} booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadRooms(); // Refresh rooms list
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book room: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
