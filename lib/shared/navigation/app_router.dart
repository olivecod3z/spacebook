import 'package:flutter/material.dart';
import 'package:spacebook/features/dashboard/screens/dashboard_screen.dart';
import 'package:spacebook/features/onboarding/screens/onboarding_screen.dart';

class AppRouter {
  static const String onboarding = '/';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    }
  }
}
