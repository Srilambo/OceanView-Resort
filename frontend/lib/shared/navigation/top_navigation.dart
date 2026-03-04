import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../features/authentication/providers/auth_provider.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final List<PopupMenuItem>? actions;

  const TopNavigationBar({
    Key? key,
    required this.title,
    this.onMenuPressed,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu Button & Title
            Expanded(
              child: Row(
                children: [
                  if (onMenuPressed != null)
                    IconButton(
                      icon: const Icon(Icons.menu),
                      color: const Color(0xFF1565C0),
                      onPressed: onMenuPressed,
                    ),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Right Actions
            Row(
              children: [
                // Search Icon
                IconButton(
                  icon: const Icon(Icons.search),
                  color: const Color(0xFF1565C0),
                  onPressed: () {
                    // Show search
                  },
                ),

                // Notifications
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      color: const Color(0xFF1565C0),
                      onPressed: () {
                        // Show notifications
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '3',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // User Profile Dropdown
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          authProvider.logout();
                        }
                        // Other actions can be handled here
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'profile',
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 18),
                              const SizedBox(width: 12),
                              Text(
                                'My Profile',
                                style: GoogleFonts.montserrat(),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'settings',
                          child: Row(
                            children: [
                              const Icon(Icons.settings, size: 18),
                              const SizedBox(width: 12),
                              Text(
                                'Settings',
                                style: GoogleFonts.montserrat(),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              const Icon(Icons.logout,
                                  size: 18, color: Colors.red),
                              const SizedBox(width: 12),
                              Text(
                                'Logout',
                                style:
                                    GoogleFonts.montserrat(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: const Color(0xFF1565C0),
                              child: Text(
                                authProvider.currentUser?.username != null &&
                                        authProvider
                                            .currentUser!.username.isNotEmpty
                                    ? authProvider.currentUser!.username
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : 'U',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              authProvider.currentUser?.username ?? 'User',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF1565C0),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
