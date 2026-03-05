import 'dart:html' as html;
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
  Map<String, dynamic>? _completedBill; // shown after payment
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() {
    setState(() {
      _completedBill = null;
      _futureReservations = ApiService.getAllReservations().then(
          (list) => list.where((res) => res.status == 'CHECKED_IN').toList());
    });
  }

  // ─── Payment dialog → checkout ─────────────────────────────────────────────
  Future<void> _showPaymentDialog(Reservation res) async {
    String selectedMethod = 'CASH';
    Map<String, dynamic>? previewBill;

    // Load current bill for preview
    try {
      previewBill = await ApiService.getBillDetails(res.reservationId);
    } catch (_) {}

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final roomCost =
                (previewBill?['roomCost'] as num?)?.toDouble() ?? res.totalCost;
            final servicesTotal =
                (previewBill?['servicesTotal'] as num?)?.toDouble() ?? 0.0;
            final grandTotal = roomCost + servicesTotal;
            final serviceItems =
                (previewBill?['serviceItems'] as List<dynamic>?) ?? [];

            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ────────────────────────────────────────────
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D47A1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.payment_rounded,
                                color: Color(0xFF0D47A1), size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Process Payment',
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0D47A1))),
                                Text(res.guestName,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey.shade600,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // ── Bill Preview ──────────────────────────────────────
                      _dialogSection('Room ${res.roomNumber} · ${res.roomType}',
                          '\$${roomCost.toStringAsFixed(2)}',
                          icon: Icons.hotel_rounded),

                      if (serviceItems.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Additional Services',
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700)),
                        const SizedBox(height: 6),
                        ...serviceItems.map((item) {
                          final price =
                              (item['servicePrice'] as num?)?.toDouble() ?? 0.0;
                          final qty = item['quantity'] ?? 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '  • ${item['serviceName']} × $qty',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                  ),
                                ),
                                Text(
                                  '\$${(price * qty).toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E)),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // ── Payment Method ────────────────────────────────────
                      Text('Select Payment Method',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: const Color(0xFF0D47A1))),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _paymentMethodChip(
                              'CASH',
                              Icons.money_rounded,
                              selectedMethod,
                              (v) => setDialogState(() => selectedMethod = v)),
                          _paymentMethodChip(
                              'CREDIT_CARD',
                              Icons.credit_card_rounded,
                              selectedMethod,
                              (v) => setDialogState(() => selectedMethod = v)),
                          _paymentMethodChip(
                              'DEBIT_CARD',
                              Icons.payment_rounded,
                              selectedMethod,
                              (v) => setDialogState(() => selectedMethod = v)),
                          _paymentMethodChip(
                              'BANK_TRANSFER',
                              Icons.account_balance_rounded,
                              selectedMethod,
                              (v) => setDialogState(() => selectedMethod = v)),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Action Buttons ────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text('Cancel',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _isProcessing
                                  ? null
                                  : () async {
                                      Navigator.pop(ctx);
                                      await _confirmCheckout(
                                          res, selectedMethod);
                                    },
                              icon: const Icon(Icons.check_circle_rounded,
                                  size: 18),
                              label: Text('Confirm & Checkout',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmCheckout(Reservation res, String paymentMethod) async {
    setState(() => _isProcessing = true);
    try {
      final bill = await ApiService.checkOutWithPayment(
        reservationId: res.reservationId,
        paymentMethod: paymentMethod,
      );
      setState(() {
        _completedBill = bill;
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text('Payment confirmed! Guest checked out.',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
            ]),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e', style: GoogleFonts.montserrat()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating),
        );
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
    body { font-family: Georgia, serif; color: #1a1a2e; background: #fff; padding: 40px; }
    .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; border-bottom: 3px solid #0D47A1; padding-bottom: 24px; }
    .logo { font-size: 28px; font-weight: bold; color: #0D47A1; }
    .logo span { color: #F57C00; }
    .logo-sub { font-size: 12px; color: #777; margin-top: 4px; }
    .section { margin: 28px 0; }
    .section-title { font-size: 13px; font-weight: bold; color: #0D47A1; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; border-left: 4px solid #F57C00; padding-left: 10px; }
    .info-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }
    .info-item label { display: block; font-size: 11px; color: #999; text-transform: uppercase; margin-bottom: 3px; }
    .info-item span { font-size: 14px; color: #1a1a2e; font-weight: 600; }
    table { width: 100%; border-collapse: collapse; margin-top: 8px; }
    thead th { background: #0D47A1; color: white; padding: 12px 16px; text-align: left; font-size: 13px; }
    tbody td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
    tbody tr:nth-child(even) { background: #fafafa; }
    .total-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; border-bottom: 1px solid #f0f0f0; }
    .total-row.grand { font-size: 20px; font-weight: bold; color: #0D47A1; border-top: 2px solid #0D47A1; border-bottom: none; padding-top: 16px; margin-top: 8px; }
    .paid-badge { display: inline-block; background: #e8f5e9; color: #2E7D32; padding: 6px 20px; border-radius: 20px; font-weight: bold; font-size: 14px; margin-top: 8px; }
    .footer { margin-top: 48px; text-align: center; color: #999; font-size: 12px; border-top: 1px solid #eee; padding-top: 20px; }
    @media print { body { padding: 20px; } }
  </style>
</head>
<body>
  <div class="header">
    <div>
      <div class="logo">Ocean<span>View</span> Resort</div>
      <div class="logo-sub">123 Ocean Drive, Maldives Islands | info@oceanview.com</div>
    </div>
    <div style="text-align:right">
      <div style="font-size:36px;font-weight:bold;color:#0D47A1">INVOICE</div>
      <div style="color:#555;margin-top:6px">#${bill['reservationNumber']}</div>
      <div style="color:#555;font-size:12px">Issued: ${DateTime.now().toString().substring(0, 10)}</div>
    </div>
  </div>
  <div class="section">
    <div class="section-title">Guest &amp; Booking Details</div>
    <div class="info-grid">
      <div class="info-item"><label>Guest Name</label><span>${bill['guestName'] ?? '-'}</span></div>
      <div class="info-item"><label>Reservation</label><span>${bill['reservationNumber'] ?? '-'}</span></div>
      <div class="info-item"><label>Room</label><span>${bill['roomNumber'] ?? '-'} (${bill['roomType'] ?? ''})</span></div>
      <div class="info-item"><label>Check-In</label><span>${(bill['checkInDate'] ?? '').toString().substring(0, 10)}</span></div>
      <div class="info-item"><label>Check-Out</label><span>${(bill['checkOutDate'] ?? '').toString().substring(0, 10)}</span></div>
      <div class="info-item"><label>Nights</label><span>${bill['numberOfNights'] ?? 0}</span></div>
    </div>
  </div>
  <div class="section">
    <div class="section-title">Room Charges</div>
    <table><thead><tr><th>Description</th><th style="text-align:center">Nights</th><th style="text-align:right">Rate/Night</th><th style="text-align:right">Amount</th></tr></thead>
    <tbody><tr>
      <td>Room ${bill['roomNumber']} – ${bill['roomType']}</td>
      <td style="text-align:center">${bill['numberOfNights']}</td>
      <td style="text-align:right">\$${pricePerNight.toStringAsFixed(2)}</td>
      <td style="text-align:right">\$${roomCost.toStringAsFixed(2)}</td>
    </tr></tbody></table>
  </div>
  ${serviceItems.isNotEmpty ? '''
  <div class="section">
    <div class="section-title">Additional Services</div>
    <table><thead><tr><th>Service</th><th style="text-align:center">Qty</th><th style="text-align:right">Price</th><th style="text-align:right">Total</th></tr></thead>
    <tbody>$servicesRows</tbody></table>
  </div>''' : ''}
  <div class="section">
    <div class="total-row"><span>Room Charges</span><span>\$${roomCost.toStringAsFixed(2)}</span></div>
    ${servicesTotal > 0 ? '<div class="total-row"><span>Additional Services</span><span>\$${servicesTotal.toStringAsFixed(2)}</span></div>' : ''}
    <div class="total-row"><span>Tax &amp; Service</span><span>\$0.00</span></div>
    <div class="total-row grand"><span>Total Paid</span><span>\$${grandTotal.toStringAsFixed(2)}</span></div>
    <div style="margin-top:12px"><span>Payment: </span>
      <span class="paid-badge">✓ PAID – ${bill['paymentMethod'] ?? ''}</span>
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

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Show bill receipt screen after payment
    if (_completedBill != null) {
      return _buildBillReceiptView(_completedBill!);
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Guest Check-out',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFC62828))),
                    const SizedBox(height: 4),
                    Text(
                        'Finalize check-out and process billing for departing guests',
                        style: GoogleFonts.montserrat(
                            color: Colors.grey.shade600)),
                  ],
                ),
              ),
              if (_isProcessing)
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
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
                        Icon(Icons.check_circle_outline_rounded,
                            size: 72, color: Colors.green.shade200),
                        const SizedBox(height: 16),
                        Text('No guests currently checked in.',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey.shade500, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('All guests have checked out.',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey.shade400, fontSize: 13)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final res = reservations[index];
                    return _buildGuestCard(res);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestCard(Reservation res) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFC62828).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  res.guestName.isNotEmpty
                      ? res.guestName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC62828)),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(res.guestName,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xFF1A1A2E))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.hotel_rounded,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Room ${res.roomNumber} · ${res.roomType}',
                          style: GoogleFonts.montserrat(
                              fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.tag_rounded,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(res.reservationNumber,
                          style: GoogleFonts.montserrat(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                          '${res.checkInDate.toString().split(' ')[0]} → ${res.checkOutDate.toString().split(' ')[0]}',
                          style: GoogleFonts.montserrat(
                              fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(width: 12),
                      Text('\$${res.totalCost.toStringAsFixed(2)} room',
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF57C00))),
                    ],
                  ),
                ],
              ),
            ),

            // Action button
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : () => _showPaymentDialog(res),
              icon: const Icon(Icons.payment_rounded, size: 18),
              label: Text('Checkout & Pay',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Bill Receipt shown to Staff after payment ─────────────────────────────
  Widget _buildBillReceiptView(Map<String, dynamic> bill) {
    final serviceItems = (bill['serviceItems'] as List<dynamic>?) ?? [];
    final roomCost = (bill['roomCost'] as num?)?.toDouble() ?? 0.0;
    final servicesTotal = (bill['servicesTotal'] as num?)?.toDouble() ?? 0.0;
    final grandTotal = (bill['grandTotal'] as num?)?.toDouble() ?? 0.0;
    final pricePerNight = (bill['pricePerNight'] as num?)?.toDouble() ?? 0.0;
    final paymentMethod = bill['paymentMethod'] as String? ?? 'CASH';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar ─────────────────────────────────────────────
              Row(
                children: [
                  IconButton.outlined(
                    onPressed: _loadReservations,
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back to Check-out list',
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Confirmed',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E7D32))),
                        Text(
                            'Guest checked out successfully · ${bill['reservationNumber']}',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _printBill(bill),
                    icon: const Icon(Icons.print_rounded, size: 18),
                    label: Text('Print / Download',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Payment success banner ───────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Received',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(
                              '\$${grandTotal.toStringAsFixed(2)} via ${paymentMethod.replaceAll('_', ' ')}',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.4)),
                      ),
                      child: Text('PAID',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Invoice card ─────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
                        ),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Ocean',
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              TextSpan(
                                  text: 'View',
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFF57C00))),
                              TextSpan(
                                  text: ' Resort',
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ]),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('INVOICE',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 2)),
                              Text('#${bill['reservationNumber']}',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Guest info grid
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              final cols = constraints.maxWidth > 500 ? 3 : 2;
                              return GridView.count(
                                crossAxisCount: cols,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 2.5,
                                children: [
                                  _infoCell('Guest', bill['guestName'] ?? '-'),
                                  _infoCell('Reservation',
                                      '#${bill['reservationNumber']}'),
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
                                  _infoCell('Nights',
                                      '${bill['numberOfNights']} nights'),
                                ],
                              );
                            }),
                          ),

                          const SizedBox(height: 20),

                          // Room charges table
                          _sectionLabel('Room Charges', Icons.hotel_rounded),
                          const SizedBox(height: 8),
                          _lineTable(
                            headers: const [
                              'Description',
                              'Nights',
                              'Rate',
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
                            const SizedBox(height: 20),
                            _sectionLabel(
                                'Additional Services', Icons.spa_rounded),
                            const SizedBox(height: 8),
                            _lineTable(
                              headers: const [
                                'Service',
                                'Qty',
                                'Price',
                                'Total'
                              ],
                              rows: serviceItems.map<List<String>>((item) {
                                final price = (item['servicePrice'] as num?)
                                        ?.toDouble() ??
                                    0.0;
                                final qty = item['quantity'] ?? 1;
                                final lineTotal =
                                    (item['lineTotal'] as num?)?.toDouble() ??
                                        0.0;
                                return [
                                  item['serviceName'] as String? ?? '-',
                                  '$qty',
                                  '\$${price.toStringAsFixed(2)}',
                                  '\$${lineTotal.toStringAsFixed(2)}',
                                ];
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Totals
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 300,
                              child: Column(
                                children: [
                                  _totRow('Room Charges',
                                      '\$${roomCost.toStringAsFixed(2)}'),
                                  if (servicesTotal > 0)
                                    _totRow('Services',
                                        '\$${servicesTotal.toStringAsFixed(2)}'),
                                  _totRow('Tax & Fees', '\$0.00'),
                                  const Divider(height: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('TOTAL PAID',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                letterSpacing: 1)),
                                        Text(
                                            '\$${grandTotal.toStringAsFixed(2)}',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.green, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                        'Paid via ${paymentMethod.replaceAll('_', ' ')}',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ]),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              'Thank you for staying at Ocean View Resort!',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D47A1)),
                            ),
                          ),
                        ],
                      ),
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

  // ─── Helpers ───────────────────────────────────────────────────────────────
  Widget _dialogSection(String label, String amount, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
            ],
            Text(label,
                style: GoogleFonts.montserrat(
                    fontSize: 13, color: Colors.grey.shade700)),
          ]),
          Text(amount,
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }

  Widget _paymentMethodChip(String method, IconData icon, String selected,
      ValueChanged<String> onSelect) {
    final isSelected = selected == method;
    final label = method.replaceAll('_', ' ');
    return GestureDetector(
      onTap: () => onSelect(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D47A1) : const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D47A1) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey.shade700)),
          ],
        ),
      ),
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
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(value,
            style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E)),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _sectionLabel(String title, IconData icon) {
    return Row(children: [
      Icon(icon, size: 16, color: const Color(0xFF0D47A1)),
      const SizedBox(width: 8),
      Text(title,
          style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D47A1))),
    ]);
  }

  Widget _lineTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
                          horizontal: 12, vertical: 10),
                      child: Text(h,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(cell.value,
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
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

  Widget _totRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: Colors.grey.shade600)),
          Text(value,
              style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }
}
