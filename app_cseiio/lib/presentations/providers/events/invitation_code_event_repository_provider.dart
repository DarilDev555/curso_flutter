import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/events/code_invitation_event_datasource_impl.dart';
import '../../../infrastructure/repositories/events/code_invitation_event_repository_impl.dart';
import '../auth/auth_provider.dart';

final invitationCodeEventRepositoryProvider = Provider((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  return CodeInvitationEventRepositoryImpl(
    codeInvitationEventDatasource: CodeInvitationEventDatasourceImpl(
      accessToken: accessToken,
    ),
  );
});
