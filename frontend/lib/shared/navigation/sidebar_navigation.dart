import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../features/authentication/providers/auth_provider.dart';

class SidebarNavigation extends StatefulWidget {
  final String currentRoute;
  final List<NavigationItem> items;
  final VoidCallback? onLogout;
  final Function(String)? onRouteSelect;

  const SidebarNavigation({
    Key? key,
    required this.currentRoute,
    required this.items,
    this.onLogout,
    this.onRouteSelect,
  }) : super(key: key);

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80 : 280,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isActive = widget.currentRoute == item.route;

                return _buildNavigationItem(
                  context,
                  item,
                  isActive,
                );
              },
            ),
          ),

          // Footer with Logout
          _buildFooter(context),
        ],
      ),
    );
  }

  // Header with Logo
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on,
              color: const Color(0xFF0D47A1),
              size: _isCollapsed ? 24 : 28,
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ocean View',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'RESORT',
                    style: GoogleFonts.montserrat(
                      fontSize: 8,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
          GestureDetector(
            onTap: () {
              setState(() => _isCollapsed = !_isCollapsed);
            },
            child: Icon(
              _isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              color: Colors.white.withOpacity(0.5),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Item
  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.onRouteSelect != null) {
              widget.onRouteSelect!(item.route);
            } else {
              // Navigator.of(context).pushNamed(item.route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF1E88E5).withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                if (isActive)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E88E5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: isActive
                            ? const Color(0xFF1E88E5)
                            : Colors.white.withOpacity(0.7),
                        size: 24,
                      ),
                      if (!_isCollapsed) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.label,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w500,
                              color: isActive
                                  ? const Color(0xFF1E88E5)
                                  : Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Footer with Logout
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // User Profile Preview
          if (!_isCollapsed) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF1565C0),
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Text(
                          authProvider.currentUser?.username.isNotEmpty == true
                              ? authProvider.currentUser!.username
                                  .substring(0, 1)
                                  .toUpperCase()
                              : 'U',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.currentUser?.username ?? 'User',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              authProvider.currentUser?.displayRole ?? 'Guest',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutConfirmation(context);
              },
              icon: const Icon(Icons.logout, size: 18),
              label: Text(
                _isCollapsed ? 'L' : 'Logout',
                style: GoogleFonts.montserrat(
                  fontSize: _isCollapsed ? 14 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Logout Confirmation
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D47A1),
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Navigation Item Model
class NavigationItem {
  final String label;
  final IconData icon;
  final String route;
  final String? role;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    this.role,
  });
}
