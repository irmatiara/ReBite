// File: lib/main.dart
import 'package:flutter/material.dart';
import 'rebite_claimer_dashboard_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebite Claimer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C5745),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5EB),
      ),
      home: const RebiteClaimerDashboardMap(),
    );
  }
}
