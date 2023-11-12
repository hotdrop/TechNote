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
  /// エントリデータの前回更新日時
  ///
  Future<DateTime?> getLastRefreshEntryDateTime() async {
    final dtEpoch = await _getInt('key002');
    return dtEpoch == 0 ? null : DateTime.fromMillisecondsSinceEpoch(dtEpoch);
  }

  Future<void> saveLastRefreshEntryDateTime(DateTime value) async {
    await _saveInt('key002', value.millisecondsSinceEpoch);
  }

  ///
  /// タグデータの前回更新日時
  ///
  Future<DateTime?> getLastRefreshTagDateTime() async {
    final dtEpoch = await _getInt('key003');
    return dtEpoch == 0 ? null : DateTime.fromMillisecondsSinceEpoch(dtEpoch);
  }

  Future<void> saveLastRefreshTagDateTime(DateTime value) async {
    await _saveInt('key003', value.microsecondsSinceEpoch);
  }

  // 以下は型別のデータ格納/取得処理

  Future<int> _getInt(String key) async {
    final prefs = await _ref.read(_sharefPregerencesProvider);
    return prefs.getInt(key) ?? 0;
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await _ref.read(_sharefPregerencesProvider);
    prefs.setInt(key, value);
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
