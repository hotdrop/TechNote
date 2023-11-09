import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/repository/app_settings_repository.dart';
import 'package:tech_note/ui/base_menu.dart';

final appInitFutureProvider = FutureProvider<void>((ref) async {
  // ここでアプリに必要な初期処理を行う
  await Future.wait([
    ref.read(entryNotifierProvider.notifier).onLoad(),
    ref.read(tagNotifierProvider.notifier).onLoad(),
  ]);

  await ref.read(appSettingsNotifierProvider.notifier).refresh();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));
});

final appSettingsNotifierProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  Future<void> refresh() async {
    final isDarkMode = await ref.read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = AppSettings(currentMode: mode);
  }

  Future<void> setDarkMode(bool isDark) async {
    if (isDark) {
      await ref.read(appSettingsRepositoryProvider).changeDarkMode();
    } else {
      await ref.read(appSettingsRepositoryProvider).changeLightMode();
    }
    refresh();
  }
}

class AppSettings {
  const AppSettings({
    this.currentMode = ThemeMode.system,
  });

  final ThemeMode currentMode;

  bool get isDarkMode => currentMode == ThemeMode.dark;

  AppSettings copyWith({ThemeMode? currentMode}) {
    return AppSettings(currentMode: currentMode ?? this.currentMode);
  }
}

final selectBaseMenuIndexProvider = StateProvider<int>((_) => BaseMenu.homeIndex);
