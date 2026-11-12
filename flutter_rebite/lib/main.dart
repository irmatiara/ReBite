import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rebite_onboarding.dart';
import 'rebite_restaurant_dashboard.dart';
import 'rebite_restaurant_profile.dart';
import 'form_post_surplus.dart';

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
      RebiteRestaurantDashboard(
        onPostSurplus: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormPostSurplus(),
            ),
          );
        },

        onOpenProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const RebiteRestaurantProfile(),
            ),
          );
        },
      ),
},

      home: const RebiteOnboarding(),
    );
  }
}