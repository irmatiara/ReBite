import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'session_storage.dart';
import 'rebite_route_tracker.dart';
import 'rebite_onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionStorage.init();
  runApp(const RebiteApp());
}

class RebiteApp extends StatelessWidget {
  const RebiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lockedRoute = RebiteRouteTracker.getLockedRoute();
    final initial = (lockedRoute != null && lockedRoute.isNotEmpty && lockedRoute != '/')
        ? lockedRoute
        : AppRoutes.onboarding;

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
      initialRoute: initial,
      onGenerateRoute: onGenerateAppRoute,
      navigatorObservers: [RebiteRouteObserver()],
    );
  }
}
