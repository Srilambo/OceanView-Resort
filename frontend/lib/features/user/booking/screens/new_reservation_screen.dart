import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../../../../models/reservation.dart';
import '../../../../models/room.dart';
import '../../../../services/api_service.dart';
import '../../../../theme/app_colors.dart';

class NewReservationScreen extends StatefulWidget {
  final String userId;

  const NewReservationScreen({super.key, required this.userId});

  @override
  State<NewReservationScreen> createState() => _NewReservationScreenState();
}

class _NewReservationScreenState extends State<NewReservationScreen>
    with TickerProviderStateMixin {
  final _specialRequestsController = TextEditingController();
  DateTime? _selectedCheckInDate;
  DateTime? _selectedCheckOutDate;
  Room? _selectedRoom;
  List<Room> _availableRooms = [];
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _loadAvailableRooms();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
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
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => _buildThemePicker(context, child!),
    );
    if (picked != null) {
      setState(() {
        _selectedCheckInDate = picked;
        if (_selectedCheckOutDate != null &&
            _selectedCheckOutDate!
                .isBefore(picked.add(const Duration(days: 1)))) {
          _selectedCheckOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (_selectedCheckInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select check-in date first'),
            backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedCheckInDate!.add(const Duration(days: 1)),
      firstDate: _selectedCheckInDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => _buildThemePicker(context, child!),
    );
    if (picked != null) {
      setState(() => _selectedCheckOutDate = picked);
    }
  }

  Widget _buildThemePicker(BuildContext context, Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.goldAccent,
          onPrimary: AppColors.darkBg,
          surface: AppColors.darkBgSecondary,
          onSurface: AppColors.textLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.goldAccent),
        ),
      ),
      child: child,
    );
  }

  Future<void> _createReservation() async {
    if (_selectedCheckInDate == null ||
        _selectedCheckOutDate == null ||
        _selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select dates and a room'),
            backgroundColor: Colors.orangeAccent),
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
          const SnackBar(
              content: Text('Reservation created successfully!'),
              backgroundColor: AppColors.sageGreen),
        );
        Navigator.of(context).pop(reservation);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'NEW RESERVATION',
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
          // Background Decor
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null) _buildErrorMessage(),
                  _buildSectionHeader('SELECT DATES'),
                  const SizedBox(height: 16),
                  _buildDateSelectors(),
                  const SizedBox(height: 40),
                  _buildSectionHeader('SELECT YOUR SANCTUARY'),
                  const SizedBox(height: 16),
                  _isLoading && _availableRooms.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.goldAccent))
                      : _buildRoomSelection(),
                  const SizedBox(height: 40),
                  _buildSectionHeader('PERSONAL REQUESTS'),
                  const SizedBox(height: 16),
                  _buildSpecialRequestsField(),
                  const SizedBox(height: 60),
                  _buildConfirmButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Row(
      children: [
        Expanded(
          child: _buildDateCard(
            'Check-in',
            _selectedCheckInDate,
            () => _selectCheckInDate(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateCard(
            'Check-out',
            _selectedCheckOutDate,
            () => _selectCheckOutDate(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(String title, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.darkBgSecondary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.goldAccent, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      date != null
                          ? DateFormat('MMM dd, yyyy').format(date)
                          : 'Select',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomSelection() {
    if (_availableRooms.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Icon(Icons.bed_outlined,
                color: AppColors.textMuted.withOpacity(0.5), size: 48),
            const SizedBox(height: 16),
            const Text(
              'No available sanctuaries for these dates.',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableRooms.length,
      itemBuilder: (context, index) {
        final room = _availableRooms[index];
        final isSelected = _selectedRoom?.roomId == room.roomId;
        return _buildRoomCard(room, isSelected);
      },
    );
  }

  Widget _buildRoomCard(Room room, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() => _selectedRoom = room),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.goldAccent.withOpacity(0.1)
                : AppColors.darkBgSecondary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? AppColors.goldAccent.withOpacity(0.5)
                  : AppColors.glassBorder.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      (isSelected ? AppColors.goldAccent : AppColors.textMuted)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.hotel_outlined,
                  color:
                      isSelected ? AppColors.goldAccent : AppColors.textMuted,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Room ${room.roomNumber} • Up to ${room.capacity} guests',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${room.pricePerNight.toInt()}',
                style: const TextStyle(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Text(
                '/n',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialRequestsField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
      ),
      child: TextField(
        controller: _specialRequestsController,
        maxLines: 4,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: 'Tell us how we can make your stay unforgettable...',
          hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
          contentPadding: const EdgeInsets.all(24),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: _isLoading ? null : AppColors.goldGradient,
        color: _isLoading ? AppColors.darkBgSecondary : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!_isLoading)
            BoxShadow(
              color: AppColors.goldAccent.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createReservation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: AppColors.darkBg)
            : const Text(
                'COMPLETE RESERVATION',
                style: TextStyle(
                  color: AppColors.darkBg,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
      ),
    );
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
        Offset(size.width * 0.2 + (i * 200) + offset, size.height * 0.6),
        150 + (animationValue * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
