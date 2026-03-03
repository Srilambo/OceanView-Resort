import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';
import '../../../../theme/app_colors.dart';

class BillScreen extends StatefulWidget {
  final String? reservationId;

  const BillScreen({super.key, this.reservationId});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> with TickerProviderStateMixin {
  final _reservationNumberController = TextEditingController();
  Bill? _bill;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    if (widget.reservationId != null) {
      _reservationNumberController.text = widget.reservationId!;
      Future.delayed(const Duration(milliseconds: 500), _generateBill);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _reservationNumberController.dispose();
    super.dispose();
  }

  Future<void> _generateBill() async {
    if (_reservationNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter reservation ID'),
            backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _bill = null;
    });

    try {
      final bill = await ApiService.getBill(_reservationNumberController.text);
      if (mounted) {
        setState(() {
          _bill = bill;
        });
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
          'INVOICE & BILLING',
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
                  _buildSearchSection(),
                  if (_errorMessage != null) _buildErrorMessage(),
                  if (_bill != null) _buildBillReceipt(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Track Reservation',
          style: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkBgSecondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _reservationNumberController,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: InputDecoration(
                    hintText: 'Enter Reservation ID',
                    hintStyle:
                        TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildGenerateButton(),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: _isLoading ? null : AppColors.goldGradient,
        color: _isLoading ? AppColors.darkBgSecondary : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _generateBill,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.darkBg))
            : const Icon(Icons.search, color: AppColors.darkBg),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
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
              child: Text(_errorMessage!,
                  style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }

  Widget _buildBillReceipt() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.darkBgSecondary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: AppColors.glassBorder.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildReceiptHeader(),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(color: AppColors.glassBorder)),
                  _buildGuestDetails(),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(color: AppColors.glassBorder)),
                  _buildCostBreakdown(),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(color: AppColors.glassBorder)),
                  _buildTotalSection(),
                  const SizedBox(height: 40),
                  _buildReceiptFooter(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildDownloadButton(),
      ],
    );
  }

  Widget _buildReceiptHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.goldAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.receipt_long,
              color: AppColors.goldAccent, size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          'OCEAN VIEW RESORT',
          style: TextStyle(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 4),
        ),
        const SizedBox(height: 4),
        Text(
          'Official Invoice - #${_bill!.reservationNumber}',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildGuestDetails() {
    return Column(
      children: [
        _buildBillItem('Guest Name', _bill!.guestName),
        _buildBillItem('Sanctuary', 'Room ${_bill!.roomNumber}'),
        _buildBillItem(
            'Arrival', DateFormat('MMM dd, yyyy').format(_bill!.checkInDate)),
        _buildBillItem('Departure',
            DateFormat('MMM dd, yyyy').format(_bill!.checkOutDate)),
        _buildBillItem('Stay Duration', '${_bill!.numberOfNights} Nights'),
      ],
    );
  }

  Widget _buildCostBreakdown() {
    return Column(
      children: [
        _buildBillItem(
            'Price Per Night', '\$${_bill!.pricePerNight.toStringAsFixed(2)}'),
        _buildBillItem('Accommodation Subtotal',
            '\$${(_bill!.pricePerNight * _bill!.numberOfNights).toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'GRAND TOTAL',
          style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1),
        ),
        Text(
          '\$${_bill!.totalCost.toStringAsFixed(2)}',
          style: const TextStyle(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildReceiptFooter() {
    return Column(
      children: [
        Text(
          'Thank you for staying with us.',
          style: TextStyle(
              color: AppColors.textMuted, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 8),
        Text(
          'Generated: ${DateFormat('MMM dd, yyyy • HH:mm').format(_bill!.generatedAt)}',
          style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.5), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildBillItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldAccent.withOpacity(0.3)),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined,
            color: AppColors.goldAccent),
        label: const Text('DOWNLOAD PDF INVOICE',
            style: TextStyle(
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5)),
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
          Offset(size.width * 0.5, size.height * 0.5 + (i * 100) - offset),
          200 + (animationValue * 50),
          paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
