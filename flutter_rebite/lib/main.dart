import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rebite_onboarding.dart';
import 'rebite_restaurant_dashboard.dart';
void main() {
  runApp(const RebiteApp());
}

class RebiteApp extends StatelessWidget {
  const RebiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReBite — Food Rescue Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrunswick,
          primary: kBrunswick,
          secondary: kTangerine,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
          routes: {
      '/restaurant-dashboard': (context) =>
          const RebiteRestaurantDashboard(),
    },
      home: const RebiteOnboarding(),
    );
  }
}
