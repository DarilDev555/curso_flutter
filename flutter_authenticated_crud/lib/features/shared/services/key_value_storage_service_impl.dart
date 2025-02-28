import 'package:flutter_authenticated_crud/features/shared/services/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharePrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharePrefs();

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;

      case String:
        return prefs.getString(key) as T?;

      default:
        throw UnimplementedError(
          'Set not implemented fpr type ${T.runtimeType}',
        );
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharePrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharePrefs();

    switch (T) {
      case const (int):
        prefs.setInt(key, value as int);
        break;

      case const (String):
        prefs.setString(key, value as String);
        break;

      default:
        throw UnimplementedError(
          'Set not implemented fpr type ${T.runtimeType}',
        );
    }
  }
}
