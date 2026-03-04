import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/authentication/providers/auth_provider.dart';
import '../../features/user/home/screens/landing_screen.dart';
import '../../features/main/screens/admin_main_screen.dart';
import '../../features/main/screens/manager_main_screen.dart';
import '../../features/main/screens/staff_main_screen.dart';
import '../../features/main/screens/guest_main_screen.dart';
import '../../features/authentication/models/user_role.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Check if user is logged in
        if (!authProvider.isLoggedIn || authProvider.currentUser == null) {
          // Navigate to landing/login
          return const LandingScreen();
        }

        // Route based on user role
        switch (authProvider.userRole) {
          case UserRole.ADMIN:
            return const AdminMainScreen();
          case UserRole.MANAGER:
            return const ManagerMainScreen();
          case UserRole.STAFF:
            return const StaffMainScreen();
          case UserRole.GUEST:
            return const GuestMainScreen();
        }
      },
    );
  }
}
