import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  String accessToken = 'accessToken';
  String profile = 'profile';
  String merchantId = 'merchantId';

  final Future<SharedPreferences> _storage = SharedPreferences.getInstance();

  Future<String?> getValueByKey(String key) async {
    SharedPreferences storage = await _storage;
    String? value = storage.getString(key);
    return Future.value(value);
  }

  Future<void> setValueByKey(String key, String value) async {
    SharedPreferences storage = await _storage;
    await storage.setString(key, value);
  }

  Future<void> deleteValueByKey(String key) async {
    SharedPreferences storage = await _storage;
    await storage.remove(key);
  }

  Future<void> deleteAllValues() async {
    SharedPreferences storage = await _storage;
    await storage.clear();
  }
}

final Preferences preferences = Preferences();