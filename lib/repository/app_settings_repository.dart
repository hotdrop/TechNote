import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/repository/local/shared_prefs.dart';

final appSettingsRepositoryProvider = Provider((ref) => _AppSettingRepository(ref));

class _AppSettingRepository {
  _AppSettingRepository(this._ref);

  final Ref _ref;

  Future<bool> isDarkMode() async {
    return await _ref.read(sharedPrefsProvider).isDarkMode();
  }

  Future<void> changeDarkMode() async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(true);
  }

  Future<void> changeLightMode() async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(false);
  }
}
