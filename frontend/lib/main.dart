import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/user/home/screens/landing_screen.dart';
import 'features/user/home/providers/booking_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const OceanViewResortApp(),
    ),
  );
}

class OceanViewResortApp extends StatelessWidget {
  const OceanViewResortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocean View Resort',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LandingScreen(),
    );
  }
}
