import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/user.dart';
import '../../../../services/api_service.dart';

class ManagerManagementView extends StatefulWidget {
  const ManagerManagementView({Key? key}) : super(key: key);

  @override
  State<ManagerManagementView> createState() => _ManagerManagementViewState();
}

class _ManagerManagementViewState extends State<ManagerManagementView> {
  late Future<List<User>> _managersFuture;

  @override
  void initState() {
    super.initState();
    _managersFuture = ApiService.getUsersByRole('ROLE_MANAGER');
  }

  void _refresh() {
    setState(() {
      _managersFuture = ApiService.getUsersByRole('ROLE_MANAGER');
    });
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
                'Manager Management',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Manager'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
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
              child: FutureBuilder<List<User>>(
                future: _managersFuture,
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
                          Text('Error loading managers',
                              style: GoogleFonts.montserrat(color: Colors.red)),
                          TextButton(
                              onPressed: _refresh, child: const Text('Retry')),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No managers found.',
                          style: GoogleFonts.montserrat(color: Colors.grey)),
                    );
                  }

                  final managerList = snapshot.data!;
                  return ListView.separated(
                    itemCount: managerList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade200, height: 1),
                    itemBuilder: (context, index) {
                      final manager = managerList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF1565C0).withOpacity(0.1),
                          child: Text(
                            manager.username.isNotEmpty
                                ? manager.username[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          manager.username,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D47A1)),
                        ),
                        subtitle: Text(
                          manager.email,
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
                                color: manager.authenticated
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                manager.authenticated ? 'Active' : 'Inactive',
                                style: GoogleFonts.montserrat(
                                  color: manager.authenticated
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 80,
                              child: Text(
                                manager.roles
                                    .map((r) => r.replaceAll('ROLE_', ''))
                                    .join(', '),
                                style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue, size: 20),
                                onPressed: () {}),
                            IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                onPressed: () {}),
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
