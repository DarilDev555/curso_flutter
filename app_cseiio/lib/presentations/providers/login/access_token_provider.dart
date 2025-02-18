import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/presentations/providers/login/login_repository_provider.dart';

final accessTokenProvider = StateNotifierProvider<AccesTokenNotifier, String>((
  ref,
) {
  final getAccessTokenCallBackProvider =
      ref.watch(loginRepositoryProvider).login;

  return AccesTokenNotifier(
    getAccessTokenCallBack: getAccessTokenCallBackProvider,
  );
});

typedef GetAccessTokenCallBack =
    Future<String> Function({String email, String password});

class AccesTokenNotifier extends StateNotifier<String> {
  bool isLoading = false;
  final GetAccessTokenCallBack getAccessTokenCallBack;

  AccesTokenNotifier({required this.getAccessTokenCallBack}) : super('');

  Future<void> getToken(String email, String password) async {
    if (isLoading) return;

    isLoading = true;
    final String accesToken = await getAccessTokenCallBack(
      email: email,
      password: password,
    );
    state = accesToken;
    isLoading = false;
  }
}
