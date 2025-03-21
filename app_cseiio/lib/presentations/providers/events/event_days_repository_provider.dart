import 'package:app_cseiio/infrastructure/datasources/events/event_days_datasource_impl.dart';
import 'package:app_cseiio/infrastructure/repositories/events/event_days_respository_impl.dart';
import 'package:app_cseiio/presentations/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventDaysRepositoryProvider = Provider((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  return EventDaysRespositoryImpl(
    eventDaysDatasource: EventDaysDatasourceImpl(accessToken: accessToken),
  );
});
