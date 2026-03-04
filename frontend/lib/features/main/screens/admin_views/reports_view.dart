import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({Key? key}) : super(key: key);

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Monthly Revenue Report',
      'date': 'Oct 01, 2026',
      'type': 'Financial',
      'status': 'Generated'
    },
    {
      'title': 'Occupancy Statistics',
      'date': 'Sep 30, 2026',
      'type': 'Operations',
      'status': 'Generated'
    },
    {
      'title': 'Staff Performance Review',
      'date': 'Sep 15, 2026',
      'type': 'HR',
      'status': 'Pending'
    },
    {
      'title': 'Maintenance Log',
      'date': 'Oct 04, 2026',
      'type': 'Operations',
      'status': 'Generated'
    },
  ];

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
                'Reports',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Export All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2D26),
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
                      color: Colors.black.withOpacity(0.05), blurRadius: 8),
                ],
              ),
              child: ListView.separated(
                itemCount: _reports.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 1),
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B2D26).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.assessment,
                          color: Color(0xFF7B2D26)),
                    ),
                    title: Text(
                      report['title'],
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D47A1)),
                    ),
                    subtitle: Text(
                      'Generated: ${report['date']}',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report['type'],
                            style: GoogleFonts.montserrat(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: report['status'] == 'Generated'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report['status'],
                            style: GoogleFonts.montserrat(
                              color: report['status'] == 'Generated'
                                  ? Colors.green
                                  : Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                            icon: const Icon(Icons.visibility,
                                color: Colors.indigo, size: 20),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.download,
                                color: Colors.blueGrey, size: 20),
                            onPressed: () {}),
                      ],
                    ),
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
