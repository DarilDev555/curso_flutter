import 'package:go_router/go_router.dart';
import 'package:movil_app_uesa/presentations/screens/attendance_record/attendance_record_screen.dart';
import 'package:movil_app_uesa/presentations/screens/home/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/attendance-record-screen',
      name: AttendanceRecordScreen.name,
      builder: (context, state) => AttendanceRecordScreen(),
    )
  ],
);
