import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rebite_onboarding.dart';

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
      home: const RebiteOnboarding(),
    );
  }
}
