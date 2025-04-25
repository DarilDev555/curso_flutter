import 'app_router_notifier.dart';
import '../../presentations/providers/auth/auth_provider.dart';
import '../../presentations/screens/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        path: '/login',
        builder: (context, state) => const LoginScreen(), //
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/attendance-record-screen',
        name: AttendanceRecordScreen.name,
        builder:
            (context, state) => AttendanceRecordScreen(
              idAttendance: int.parse(
                state.uri.queryParameters['idAttendance'] ?? '-1',
              ),
            ),
      ),
      GoRoute(
        path: '/dashboard-screen',
        name: DashboardScreen.name,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/teachers-dashboard-screen',
        name: TeachersDashboardScreen.name,
        builder: (context, state) => const TeachersDashboardScreen(),
      ),
      GoRoute(
        path: '/events-screen',
        name: EventsScreen.name,
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/event-days-screen',
        name: EventDaysScreen.name,
        builder: (context, state) {
          final String idEvent = state.uri.queryParameters['event'] ?? 'no-id';
          final String? mounth = state.uri.queryParameters['mounth'];
          final String? year = state.uri.queryParameters['year'];

          return EventDaysScreen(idEvent: idEvent, mounth: mounth, year: year);
        },
      ),

      GoRoute(
        path: '/attendance-screen/:eventDay',
        name: AttendanceScreen.name,
        builder: (context, state) {
          final idEvent = state.pathParameters['eventDay'] ?? 'no-id';

          return AttendanceScreen(idEventDay: idEvent);
        },
      ),
      GoRoute(
        path: '/institution-screen',
        name: InstitutionsScreen.name,
        builder: (context, state) {
          return const InstitutionsScreen();
        },
      ),
      GoRoute(
        path: '/register-screen',
        name: RegistersScreen.name,
        builder: (context, state) {
          return const RegistersScreen();
        },
      ),
      GoRoute(
        path: '/institution-detail-screen/:idInstitution',
        name: InstitutionDetailScreen.name,
        builder: (context, state) {
          final idInstitution =
              state.pathParameters['idInstitution'] ?? 'no-id';

          return InstitutionDetailScreen(idInstitution: idInstitution);
        },
      ),
      GoRoute(
        path: '/teacher-detail-screen/:idTeacher',
        name: TeacherDetailScreen.name,
        builder: (context, state) {
          final idTeacher = state.pathParameters['idTeacher'] ?? 'no-id';

          return TeacherDetailScreen(idTeacher: idTeacher);
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
          return '/dashboard-screen';
        }
      }

      return null;
    },
  );
});
