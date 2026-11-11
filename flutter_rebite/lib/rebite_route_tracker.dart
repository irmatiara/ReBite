// ============================================================================
// REBITE ROUTE TRACKER & ROUTE LOCKER SERVICE
// Mengunci halaman aktif agar ketika user merefresh aplikasi (F5 / browser refresh)
// aplikasi TIDAK kembali ke halaman Onboarding dan TIDAK kembali ke dashboard,
// melainkan tetap berada tepat di halaman yang sedang aktif.
// ============================================================================

import 'package:flutter/material.dart';
import 'session_storage.dart';
import 'rebite_onboarding.dart';
import 'rebite_login.dart';
import 'rebite_partner_login.dart';
import 'rebite_partner_claimer_signup.dart';
import 'rebite_claimer_dashboard_map.dart';
import 'rebite_restaurant_dashboard.dart';
import 'claim_history.dart';
import 'food_detail.dart';
import 'rebite_claimer_profile.dart';
import 'sidejob_missions.dart';
import 'sidejob_register.dart';

/// Daftar route resmi aplikasi ReBite
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String partnerLogin = '/partner-login';
  static const String claimerSignup = '/claimer-signup';
  static const String partnerSignup = '/partner-signup';
  static const String claimerDashboard = '/claimer-dashboard';
  static const String restaurantDashboard = '/restaurant-dashboard';
  static const String claimHistory = '/claim-history';
  static const String foodDetail = '/food-detail';
  static const String claimerProfile = '/claimer-profile';
  static const String sidejobMissions = '/sidejob-missions';
  static const String sidejobRegister = '/sidejob-register';
}

/// Pengelola penguncian route aktif
class RebiteRouteTracker {
  static const String _lockedRouteKey = 'rebite_locked_route_key';
  static const String _lockedArgsKey = 'rebite_locked_route_args';

  /// Menyimpan halaman yang sedang aktif ke penyimpanan persisten
  static void lockRoute(String routeName, {dynamic args}) {
    if (routeName.isEmpty || routeName == '/') return;
    SessionStorage.setItem(_lockedRouteKey, routeName);
    if (args != null) {
      SessionStorage.setItem(_lockedArgsKey, args);
    } else {
      SessionStorage.removeItem(_lockedArgsKey);
    }
  }

  /// Mengambil halaman yang sedang terkunci
  static String? getLockedRoute() {
    final route = SessionStorage.getItem(_lockedRouteKey);
    if (route is String && route.isNotEmpty && route != '/') {
      return route;
    }
    return null;
  }

  /// Mengambil parameter / argumen halaman yang terkunci
  static dynamic getLockedArgs() {
    return SessionStorage.getItem(_lockedArgsKey);
  }

  /// Menghapus kunci halaman (misalnya saat user melakukan logout)
  static void clearLockedRoute() {
    SessionStorage.removeItem(_lockedRouteKey);
    SessionStorage.removeItem(_lockedArgsKey);
  }

  /// Menentukan nama route berdasarkan tipe Widget
  static String? routeNameForWidget(Widget page) {
    if (page is RebiteOnboarding) return AppRoutes.onboarding;
    if (page is RebiteLoginPage) return AppRoutes.login;
    if (page is RebitePartnerLoginPage) return AppRoutes.partnerLogin;
    if (page is RebitePartnerClaimerSignupPage) {
      return page.initialRole == 'resto'
          ? AppRoutes.partnerSignup
          : AppRoutes.claimerSignup;
    }
    if (page is RebiteClaimerDashboardMap) return AppRoutes.claimerDashboard;
    if (page is RebiteRestaurantDashboard) return AppRoutes.restaurantDashboard;
    if (page is ClaimHistory) return AppRoutes.claimHistory;
    if (page is FoodDetail) return AppRoutes.foodDetail;
    if (page is RebiteClaimerProfile) return AppRoutes.claimerProfile;
    if (page is SidejobMissions) return AppRoutes.sidejobMissions;
    if (page is SidejobRegister) return AppRoutes.sidejobRegister;
    return null;
  }

  /// Menentukan argumen default berdasarkan widget
  static dynamic argsForWidget(Widget page) {
    if (page is FoodDetail) return page.id;
    return null;
  }

  /// Membuat MaterialPageRoute yang otomatis terkunci dan terdaftar ke browser URL
  static Route<T> createPageRoute<T>(
    Widget page, {
    String? routeName,
    dynamic args,
  }) {
    final name = routeName ?? routeNameForWidget(page);
    final routeArgs = args ?? argsForWidget(page);
    if (name != null) {
      lockRoute(name, args: routeArgs);
    }
    return MaterialPageRoute<T>(
      settings: RouteSettings(name: name, arguments: routeArgs),
      builder: (_) => page,
    );
  }

  /// Helper untuk push halaman yang otomatis mengunci route
  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    String? routeName,
    dynamic args,
  }) {
    return Navigator.of(context).push<T>(
      createPageRoute<T>(page, routeName: routeName, args: args),
    );
  }

  /// Helper untuk push replacement yang otomatis mengunci route
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget page, {
    String? routeName,
    dynamic args,
  }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      createPageRoute<T>(page, routeName: routeName, args: args),
    );
  }
}

/// Observer navigator untuk mendeteksi setiap perpindahan halaman
class RebiteRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkAndLock(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _checkAndLock(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _checkAndLock(previousRoute);
  }

  void _checkAndLock(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null && name.isNotEmpty && name != '/') {
      RebiteRouteTracker.lockRoute(name, args: route.settings.arguments);
    }
  }
}

/// Generator route terpusat untuk aplikasi ReBite
Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
  final rawName = settings.name ?? '/';
  final uri = Uri.parse(rawName);
  var targetRoute = uri.path;

  // Jika nama route adalah root '/' atau kosong (misal saat browser refresh),
  // baca halaman yang sedang terkunci dari persistent storage.
  if (targetRoute == '/' || targetRoute.isEmpty) {
    final locked = RebiteRouteTracker.getLockedRoute();
    if (locked != null && locked.isNotEmpty && locked != '/') {
      targetRoute = locked;
    } else {
      targetRoute = AppRoutes.onboarding;
    }
  }

  // Ambil argumen dari settings atau locked args atau query param (?id=...)
  dynamic args = settings.arguments ?? RebiteRouteTracker.getLockedArgs();
  if (uri.queryParameters.containsKey('id')) {
    final parsedId = int.tryParse(uri.queryParameters['id']!);
    if (parsedId != null) args = parsedId;
  }

  // Kunci route yang aktif
  RebiteRouteTracker.lockRoute(targetRoute, args: args);

  Widget page;
  switch (targetRoute) {
    case AppRoutes.onboarding:
      page = const RebiteOnboarding();
      break;
    case AppRoutes.login:
      page = const RebiteLoginPage();
      break;
    case AppRoutes.partnerLogin:
      page = const RebitePartnerLoginPage();
      break;
    case AppRoutes.claimerSignup:
      page = const RebitePartnerClaimerSignupPage(initialRole: 'claimer');
      break;
    case AppRoutes.partnerSignup:
      page = const RebitePartnerClaimerSignupPage(initialRole: 'resto');
      break;
    case AppRoutes.claimerDashboard:
      page = const RebiteClaimerDashboardMap();
      break;
    case AppRoutes.restaurantDashboard:
      page = const RebiteRestaurantDashboard();
      break;
    case AppRoutes.claimHistory:
      page = const ClaimHistory();
      break;
    case AppRoutes.foodDetail:
      int? foodId;
      if (args is int) {
        foodId = args;
      } else if (args is Map && args['id'] != null) {
        foodId = int.tryParse(args['id'].toString());
      }
      page = FoodDetail(id: foodId);
      break;
    case AppRoutes.claimerProfile:
      page = const RebiteClaimerProfile();
      break;
    case AppRoutes.sidejobMissions:
      page = const SidejobMissions();
      break;
    case AppRoutes.sidejobRegister:
      page = const SidejobRegister();
      break;
    default:
      page = const RebiteOnboarding();
      break;
  }

  return MaterialPageRoute(
    builder: (_) => page,
    settings: RouteSettings(name: targetRoute, arguments: args),
  );
}
