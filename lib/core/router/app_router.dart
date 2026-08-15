import 'package:go_router/go_router.dart';

import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/customer/customer_home_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',

    routes: [
      // ============================================================
      // LOGIN
      // ============================================================
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      // ============================================================
      // REGISTER
      // ============================================================
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      // ============================================================
      // CUSTOMER
      // ============================================================
      GoRoute(
        path: '/customer',
        builder: (context, state) {
          return const CustomerHomeScreen();
        },
      ),

      // ============================================================
      // ADMIN
      // ============================================================
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          return const AdminDashboardScreen();
        },
      ),
    ],
  );
}
