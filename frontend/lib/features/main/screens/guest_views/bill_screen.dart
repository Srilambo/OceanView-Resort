import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_service.dart';

class BillScreen extends StatefulWidget {
  final String reservationId;
  final String reservationNumber;

  const BillScreen({
    Key? key,
    required this.reservationId,
    required this.reservationNumber,
  }) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _futureBill;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadBill();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  void _loadBill() {
    setState(() {
      _futureBill = ApiService.getBillDetails(widget.reservationId);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment(Map<String, dynamic> bill) async {
    String selectedMethod = 'CREDIT_CARD';

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Complete Payment',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to pay the total amount of \$${(bill['grandTotal'] as num).toStringAsFixed(2)}.',
              style: GoogleFonts.montserrat(),
            ),
            const SizedBox(height: 16),
            Text('Select Payment Method:',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Credit Card'),
                      value: 'CREDIT_CARD',
                      groupValue: selectedMethod,
                      onChanged: (v) =>
                          setDialogState(() => selectedMethod = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Debit Card'),
                      value: 'DEBIT_CARD',
                      groupValue: selectedMethod,
                      onChanged: (v) =>
                          setDialogState(() => selectedMethod = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Bank Transfer'),
                      value: 'BANK_TRANSFER',
                      groupValue: selectedMethod,
                      onChanged: (v) =>
                          setDialogState(() => selectedMethod = v!),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white),
            child: const Text('Confirm Payment'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      try {
        await ApiService.checkOutWithPayment(
          reservationId: widget.reservationId,
          paymentMethod: selectedMethod,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Payment successful!'),
                backgroundColor: Colors.green),
          );
          _loadBill(); // Refresh bill status
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  void _printBill(Map<String, dynamic> bill) {
    final serviceItems = (bill['serviceItems'] as List<dynamic>?) ?? [];

    String servicesRows = '';
    for (final item in serviceItems) {
      final name = item['serviceName'] ?? '';
      final qty = item['quantity'] ?? 1;
      final price = (item['servicePrice'] as num?)?.toDouble() ?? 0.0;
      final total = (item['lineTotal'] as num?)?.toDouble() ?? 0.0;
      servicesRows += '''
        <tr>
          <td>$name</td>
          <td style="text-align:center">$qty</td>
          <td style="text-align:right">\$${price.toStringAsFixed(2)}</td>
          <td style="text-align:right">\$${total.toStringAsFixed(2)}</td>
        </tr>''';
    }

    final roomCost = (bill['roomCost'] as num?)?.toDouble() ?? 0.0;
    final servicesTotal = (bill['servicesTotal'] as num?)?.toDouble() ?? 0.0;
    final grandTotal = (bill['grandTotal'] as num?)?.toDouble() ?? 0.0;
    final pricePerNight = (bill['pricePerNight'] as num?)?.toDouble() ?? 0.0;

    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Invoice - ${bill['reservationNumber']}</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Georgia', serif; color: #1a1a2e; background: #fff; padding: 40px; }
    .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; border-bottom: 3px solid #0D47A1; padding-bottom: 24px; }
    .logo { font-size: 28px; font-weight: bold; color: #0D47A1; }
    .logo span { color: #F57C00; }
    .logo-sub { font-size: 12px; color: #777; margin-top: 4px; }
    .invoice-title { font-size: 36px; color: #0D47A1; font-weight: bold; }
    .invoice-meta { font-size: 13px; color: #555; margin-top: 6px; }
    .section { margin: 28px 0; }
    .section-title { font-size: 13px; font-weight: bold; color: #0D47A1; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; border-left: 4px solid #F57C00; padding-left: 10px; }
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .info-item label { display: block; font-size: 11px; color: #999; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 3px; }
    .info-item span { font-size: 14px; color: #1a1a2e; font-weight: 600; }
    table { width: 100%; border-collapse: collapse; margin-top: 8px; }
    thead th { background: #0D47A1; color: white; padding: 12px 16px; text-align: left; font-size: 13px; font-weight: 600; }
    tbody td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
    tbody tr:last-child td { border-bottom: none; }
    tbody tr:nth-child(even) { background: #fafafa; }
    .totals { margin-top: 24px; }
    .total-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; border-bottom: 1px solid #f0f0f0; }
    .total-row.grand { font-size: 20px; font-weight: bold; color: #0D47A1; border-top: 2px solid #0D47A1; border-bottom: none; padding-top: 16px; margin-top: 8px; }
    .payment-badge { display: inline-block; background: #e8f5e9; color: #2E7D32; padding: 6px 16px; border-radius: 20px; font-weight: bold; font-size: 13px; margin-top: 4px; }
    .footer { margin-top: 48px; text-align: center; color: #999; font-size: 12px; border-top: 1px solid #eee; padding-top: 20px; }
    @media print { body { padding: 20px; } }
  </style>
</head>
<body>
  <div class="header">
    <div>
      <div class="logo">Ocean<span>View</span> Resort</div>
      <div class="logo-sub">123 Ocean Drive, Maldives Islands | +94 11 234 5678 | info@oceanview.com</div>
    </div>
    <div style="text-align:right">
      <div class="invoice-title">INVOICE</div>
      <div class="invoice-meta">#${bill['reservationNumber']}</div>
      <div class="invoice-meta">Issued: ${DateTime.now().toString().substring(0, 10)}</div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">Guest &amp; Booking Details</div>
    <div class="info-grid">
      <div class="info-item"><label>Guest Name</label><span>${bill['guestName'] ?? '-'}</span></div>
      <div class="info-item"><label>Reservation No.</label><span>${bill['reservationNumber'] ?? '-'}</span></div>
      <div class="info-item"><label>Room</label><span>${bill['roomNumber'] ?? '-'} (${bill['roomType'] ?? ''})</span></div>
      <div class="info-item"><label>Nights</label><span>${bill['numberOfNights'] ?? 0} Nights</span></div>
      <div class="info-item"><label>Check-In</label><span>${(bill['checkInDate'] ?? '').toString().substring(0, 10)}</span></div>
      <div class="info-item"><label>Check-Out</label><span>${(bill['checkOutDate'] ?? '').toString().substring(0, 10)}</span></div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">Room Charges</div>
    <table>
      <thead><tr><th>Description</th><th style="text-align:center">Nights</th><th style="text-align:right">Rate/Night</th><th style="text-align:right">Amount</th></tr></thead>
      <tbody>
        <tr>
          <td>Room ${bill['roomNumber']} - ${bill['roomType']}</td>
          <td style="text-align:center">${bill['numberOfNights']}</td>
          <td style="text-align:right">\$${pricePerNight.toStringAsFixed(2)}</td>
          <td style="text-align:right">\$${roomCost.toStringAsFixed(2)}</td>
        </tr>
      </tbody>
    </table>
  </div>

  ${serviceItems.isNotEmpty ? '''
  <div class="section">
    <div class="section-title">Additional Services</div>
    <table>
      <thead><tr><th>Service</th><th style="text-align:center">Qty</th><th style="text-align:right">Price</th><th style="text-align:right">Total</th></tr></thead>
      <tbody>$servicesRows</tbody>
    </table>
  </div>
  ''' : ''}

  <div class="totals">
    <div class="total-row"><span>Room Charges</span><span>\$${roomCost.toStringAsFixed(2)}</span></div>
    ${servicesTotal > 0 ? '<div class="total-row"><span>Additional Services</span><span>\$${servicesTotal.toStringAsFixed(2)}</span></div>' : ''}
    <div class="total-row"><span>Tax &amp; Service (0%)</span><span>\$0.00</span></div>
    <div class="total-row grand"><span>Total Amount Due</span><span>\$${grandTotal.toStringAsFixed(2)}</span></div>
    <div style="margin-top:16px">
      <span>Payment Status:</span>
      <span class="payment-badge">${bill['paymentStatus'] ?? 'PENDING'}</span>
    </div>
  </div>

  <div class="footer">
    <p>Thank you for staying at Ocean View Resort. We hope to welcome you back soon.</p>
    <p style="margin-top:6px">This is a computer-generated invoice. No signature required.</p>
  </div>
  <script>window.onload = function() { window.print(); }</script>
</body>
</html>''';

    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bill – ${widget.reservationNumber}',
          style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: _futureBill,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => _printBill(snapshot.data!),
                icon: const Icon(Icons.print_rounded, color: Colors.white),
                label: Text('Print / Download',
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureBill,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: Colors.red.shade300, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load bill: ${snapshot.error}',
                      style: GoogleFonts.montserrat(color: Colors.red)),
                ],
              ),
            );
          }

          final bill = snapshot.data!;
          return FadeTransition(
            opacity: _fadeIn,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInvoiceCard(bill),
                      const SizedBox(height: 32),
                      if (bill['paymentStatus'] != 'PAID' &&
                          bill['reservationStatus'] == 'CHECKED_IN')
                        ElevatedButton.icon(
                          onPressed:
                              _isProcessing ? null : () => _handlePayment(bill),
                          icon: _isProcessing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.payment_rounded, size: 20),
                          label: Text('Pay & Check-out Now',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            shadowColor: Colors.black26,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> bill) {
    final serviceItems = (bill['serviceItems'] as List<dynamic>?) ?? [];
    final roomCost = (bill['roomCost'] as num?)?.toDouble() ?? 0.0;
    final servicesTotal = (bill['servicesTotal'] as num?)?.toDouble() ?? 0.0;
    final grandTotal = (bill['grandTotal'] as num?)?.toDouble() ?? 0.0;
    final pricePerNight = (bill['pricePerNight'] as num?)?.toDouble() ?? 0.0;
    final paymentStatus = bill['paymentStatus'] as String? ?? 'PENDING';
    final isPaid = paymentStatus == 'PAID';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Invoice Header ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ocean',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: 'View',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF57C00)),
                          ),
                          TextSpan(
                            text: ' Resort',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '123 Ocean Drive, Maldives  |  info@oceanview.com',
                      style: GoogleFonts.montserrat(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('INVOICE',
                        style: GoogleFonts.montserrat(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2)),
                    const SizedBox(height: 4),
                    Text('#${bill['reservationNumber']}',
                        style: GoogleFonts.montserrat(
                            color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                        'Issued: ${DateTime.now().toString().substring(0, 10)}',
                        style: GoogleFonts.montserrat(
                            color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Guest Info ─────────────────────────────────────────────
                _buildSectionTitle(
                    'Booking Details', Icons.person_outline_rounded),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final cols = constraints.maxWidth > 500 ? 3 : 2;
                    return GridView.count(
                      crossAxisCount: cols,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        _infoCell('Guest Name', bill['guestName'] ?? '-'),
                        _infoCell(
                            'Reservation', '#${bill['reservationNumber']}'),
                        _infoCell('Room',
                            '${bill['roomNumber']} · ${bill['roomType'] ?? ''}'),
                        _infoCell(
                            'Check-In',
                            (bill['checkInDate'] ?? '')
                                .toString()
                                .substring(0, 10)),
                        _infoCell(
                            'Check-Out',
                            (bill['checkOutDate'] ?? '')
                                .toString()
                                .substring(0, 10)),
                        _infoCell(
                            'Nights', '${bill['numberOfNights'] ?? 0} nights'),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 28),

                // ── Room Charges ───────────────────────────────────────────
                _buildSectionTitle('Room Charges', Icons.hotel_rounded),
                const SizedBox(height: 12),
                _buildLineItemTable(
                  headers: const [
                    'Description',
                    'Nights',
                    'Rate / Night',
                    'Amount'
                  ],
                  rows: [
                    [
                      'Room ${bill['roomNumber']} – ${bill['roomType']}',
                      '${bill['numberOfNights']}',
                      '\$${pricePerNight.toStringAsFixed(2)}',
                      '\$${roomCost.toStringAsFixed(2)}',
                    ]
                  ],
                ),

                if (serviceItems.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  _buildSectionTitle('Additional Services', Icons.spa_rounded),
                  const SizedBox(height: 12),
                  _buildLineItemTable(
                    headers: const ['Service', 'Qty', 'Price Each', 'Total'],
                    rows: serviceItems.map<List<String>>((item) {
                      final price =
                          (item['servicePrice'] as num?)?.toDouble() ?? 0.0;
                      final qty = item['quantity'] ?? 1;
                      final lineTotal =
                          (item['lineTotal'] as num?)?.toDouble() ?? 0.0;
                      return [
                        item['serviceName'] as String? ?? '-',
                        '$qty',
                        '\$${price.toStringAsFixed(2)}',
                        '\$${lineTotal.toStringAsFixed(2)}',
                      ];
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 28),

                // ── Totals ─────────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 340,
                    child: Column(
                      children: [
                        _totalRow(
                            'Room Charges', '\$${roomCost.toStringAsFixed(2)}'),
                        if (servicesTotal > 0)
                          _totalRow('Additional Services',
                              '\$${servicesTotal.toStringAsFixed(2)}'),
                        _totalRow('Tax & Fees', '\$0.00'),
                        const Divider(thickness: 2, height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TOTAL DUE',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1)),
                              Text('\$${grandTotal.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Payment Status ──────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isPaid
                              ? Colors.green.shade200
                              : Colors.orange.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPaid
                                ? Icons.check_circle_rounded
                                : Icons.pending_rounded,
                            color: isPaid ? Colors.green : Colors.orange,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isPaid ? 'PAID' : paymentStatus,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: isPaid ? Colors.green : Colors.orange,
                              fontSize: 13,
                            ),
                          ),
                          if (bill['paymentMethod'] != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '· ${bill['paymentMethod'].replaceAll('_', ' ')}',
                              style: GoogleFonts.montserrat(
                                color: isPaid
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Footer ──────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Thank you for choosing Ocean View Resort!',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D47A1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For inquiries about this invoice, please contact us at info@oceanview.com',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF0D47A1), size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D47A1),
          ),
        ),
      ],
    );
  }

  Widget _infoCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
        const SizedBox(height: 3),
        Text(value,
            style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E)),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildLineItemTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
            children: headers
                .map((h) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(h,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ))
                .toList(),
          ),
          ...rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return TableRow(
              decoration: BoxDecoration(
                color: i.isEven ? Colors.white : const Color(0xFFF8F9FC),
              ),
              children: row.asMap().entries.map((cell) {
                final isRight = cell.key >= 1;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(cell.value,
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: const Color(0xFF1A1A2E),
                          fontWeight: cell.key == row.length - 1
                              ? FontWeight.w600
                              : FontWeight.normal),
                      textAlign: isRight ? TextAlign.right : TextAlign.left),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: Colors.grey.shade600)),
          Text(value,
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }
}
