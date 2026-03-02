import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reservation.dart';
import '../services/api_service.dart';

class BillScreen extends StatefulWidget {
  final String? reservationId;

  const BillScreen({super.key, this.reservationId});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final _reservationNumberController = TextEditingController();
  Bill? _bill;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _generateBill() async {
    if (_reservationNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter reservation ID')),
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
      setState(() {
        _bill = bill;
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
  void initState() {
    super.initState();
    if (widget.reservationId != null) {
      _reservationNumberController.text = widget.reservationId!;
      Future.delayed(const Duration(milliseconds: 500), _generateBill);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Bill'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Reservation ID',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reservationNumberController,
                    decoration: InputDecoration(
                      hintText: 'Reservation ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Generate'),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            if (_bill != null) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'BILL',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _BillRow('Reservation #', _bill!.reservationNumber),
                      _BillRow('Guest Name', _bill!.guestName),
                      _BillRow('Room', _bill!.roomNumber),
                      const SizedBox(height: 16),
                      _BillRow(
                        'Check-in',
                        DateFormat('MMM dd, yyyy').format(_bill!.checkInDate),
                      ),
                      _BillRow(
                        'Check-out',
                        DateFormat('MMM dd, yyyy').format(_bill!.checkOutDate),
                      ),
                      _BillRow('Number of Nights', '${_bill!.numberOfNights}'),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Column(
                          children: [
                            _BillRow(
                              'Price per Night',
                              '\$${_bill!.pricePerNight.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 8),
                            _BillRow(
                              'Subtotal',
                              '\$${(_bill!.pricePerNight * _bill!.numberOfNights).toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _BillRow(
                        'TOTAL COST',
                        '\$${_bill!.totalCost.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Generated on ${DateFormat('MMM dd, yyyy HH:mm').format(_bill!.generatedAt)}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reservationNumberController.dispose();
    super.dispose();
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BillRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : null,
          ),
          Text(
            value,
            style: isBold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : null,
          ),
        ],
      ),
    );
  }
}
