import 'package:app_cseiio/config/router/app_router_notifier.dart';
import 'package:app_cseiio/presentations/providers/auth/auth_provider.dart';
import 'package:app_cseiio/presentations/screens/auth/check_auth_status_screen.dart';
import 'package:app_cseiio/presentations/screens/event/event_days_screen.dart';
import 'package:app_cseiio/presentations/screens/event/events_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_cseiio/presentations/screens/attendance_record/attendance_record_screen.dart';
import 'package:app_cseiio/presentations/screens/dashboard/dashboard_screen.dart';
import 'package:app_cseiio/presentations/screens/dashboard/menu_dashboard/teacher/teachers_dashboard_screen.dart';

import '../../presentations/screens/auth/login_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(), //
      ),

      GoRoute(
        path: '/attendance-record-screen',
        name: AttendanceRecordScreen.name,
        builder: (context, state) => AttendanceRecordScreen(),
      ),
      GoRoute(
        path: '/dashboard-screen',
        name: DashboardScreen.name,
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        path: '/teachers-dashboard-screen',
        name: TeachersDashboardScreen.name,
        builder: (context, state) => TeachersDashboardScreen(),
      ),
      GoRoute(
        path: '/events-screen',
        name: EventsScreen.name,
        builder: (context, state) => EventsScreen(),
      ),
      GoRoute(
        path: '/event-days-screen/:event',
        name: EventDaysScreen.name,
        builder: (context, state) {
          final idEvent = state.pathParameters['event'] ?? 'no-id';

          return EventDaysScreen(idEvent: idEvent);
        },
      ),
    ],

    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        }
        return '/login';
      }
      if (authStatus == AuthStatus.authenticated &&
          ref.read(authProvider).user!.role.name == 'Manager') {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/dashboard-screen';
        }
      }

      if (authStatus == AuthStatus.authenticated &&
          ref.read(authProvider).user!.role.name == 'Register') {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/attendance-record-screen';
        }
      }

      return null;
    },
  );
});
