import '../../presentations/screens/auth/register_teacher_user_screen.dart';
import '../../presentations/screens/event/event_create_update_screen.dart';
import '../../presentations/screens/event/event_days_create_update_screen.dart';
import '../../presentations/screens/event/events_incomplete_screen.dart';
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
        path: '/register-teacher-user',
        name: RegisterTeacherUserScreen.name,
        builder: (context, state) => const RegisterTeacherUserScreen(), //
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterUserScreen(),
      ),

      GoRoute(
        path: '/attendance-record-screen',
        name: AttendanceRecordScreen.name,
        builder:
            (context, state) => AttendanceRecordScreen(
              idAttendance: int.parse(
                state.uri.queryParameters['idAttendance'] ?? '-1',
              ),
              idEvent: state.uri.queryParameters['idEvent'] ?? 'no-id',
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

          return EventDaysScreen(idEvent: idEvent);
        },
      ),
      GoRoute(
        path: '/events-incomplete-screen',
        name: IncompleteEventsScreen.name,
        builder: (context, state) {
          return const IncompleteEventsScreen();
        },
      ),
      GoRoute(
        path: '/event-create-update-screen',
        name: EventCreateUpdateScreen.name,
        builder: (context, state) {
          return const EventCreateUpdateScreen();
        },
      ),

      GoRoute(
        path: '/event-days-create-update-screen',
        name: EventDaysCreateUpdateScreen.name,
        builder: (context, state) {
          return const EventDaysCreateUpdateScreen();
        },
      ),

      GoRoute(
        path: '/attendance-screen/:eventDay/:event',
        name: AttendanceScreen.name,
        builder: (context, state) {
          final idEventDay = state.pathParameters['eventDay'] ?? 'no-id';
          final idEvent = state.pathParameters['event'] ?? 'no-id';

          return AttendanceScreen(idEventDay: idEventDay, idEvent: idEvent);
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
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/register-teacher-user') {
          return null;
        }
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated &&
          ref.read(authProvider).user!.role.name == 'Manager') {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash' ||
            isGoingTo == '/register-teacher-user') {
          return '/dashboard-screen';
        }
      }

      if (authStatus == AuthStatus.authenticated &&
          ref.read(authProvider).user!.role.name == 'Register') {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash' ||
            isGoingTo == '/register-teacher-user') {
          return '/dashboard-screen';
        }
      }

      if (authStatus == AuthStatus.authenticated &&
          ref.read(authProvider).user!.role.name == 'Teacher') {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash' ||
            isGoingTo == '/register-teacher-user') {
          return '/dashboard-screen';
        }
      }

      return null;
    },
  );
});
