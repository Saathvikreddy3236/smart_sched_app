import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/landing/presentation/screens/landing_page.dart';
import '../constants/app_strings.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppStrings.landingRoute,
    routes: [
      GoRoute(
        path: AppStrings.landingRoute,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppStrings.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
});
