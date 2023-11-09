import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider((ref) => _SharedPrefs(ref));
final _sharefPregerencesProvider = Provider((ref) async => await SharedPreferences.getInstance());

class _SharedPrefs {
  const _SharedPrefs(this._ref);

  final Ref _ref;

  ///
  /// テーマモードの設定
  ///
  Future<bool> isDarkMode() async => await _getBool('key001', defaultValue: false);
  Future<void> saveDarkMode(bool value) async {
    await _saveBool('key001', value);
  }

  ///
  /// TODO エントリデータの取得日時
  ///
  // Future<String?> getLastRefreshEntryDateTime() async => await _getString('key002');
  // Future<void> saveLastRefreshEntryDateTime(String value) async {
  //   await _saveString('key002', value);
  // }

  // 以下は型別のデータ格納/取得処理
  Future<String?> _getString(String key) async {
    final prefs = await _ref.read(_sharefPregerencesProvider);
    return prefs.getString(key);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await _ref.read(_sharefPregerencesProvider);
    prefs.setString(key, value);
  }

  Future<bool> _getBool(String key, {required bool defaultValue}) async {
    final prefs = await _ref.read(_sharefPregerencesProvider);
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await _ref.read(_sharefPregerencesProvider);
    prefs.setBool(key, value);
  }
}
