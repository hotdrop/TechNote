import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/repository/app_settings_repository.dart';
import 'package:tech_note/repository/local/local_data_source.dart';
import 'package:tech_note/ui/base_menu.dart';

final appInitFutureProvider = FutureProvider<void>((ref) async {
  // ここでアプリに必要な初期処理を行う
  await ref.read(localDataSourceProvider).init();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));

  final user = await ref.read(appSettingsRepositoryProvider).signInWithGoogle();
  if (user == null) {
    throw Exception('Google SignInに失敗しました。userがnullです。');
  }

  await Future.wait([
    ref.read(entryNotifierProvider.notifier).onLoad(),
    ref.read(tagNotifierProvider.notifier).onLoad(),
  ]);

  await ref.read(appSettingsNotifierProvider.notifier).refresh(name: user.displayName, email: user.email!);
});

final appSettingsNotifierProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  Future<void> refresh({required String? name, required String email}) async {
    final isDarkMode = await ref.read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = AppSettings(loginUserName: name ?? 'ー', loginEmail: email, currentMode: mode);
  }

  Future<void> setDarkMode(bool isDark) async {
    if (isDark) {
      await ref.read(appSettingsRepositoryProvider).changeDarkMode();
    } else {
      await ref.read(appSettingsRepositoryProvider).changeLightMode();
    }
    final isDarkMode = await ref.read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(currentMode: mode);
  }
}

class AppSettings {
  const AppSettings({
    this.loginUserName = '',
    this.loginEmail = '',
    this.currentMode = ThemeMode.system,
  });

  final String loginUserName;
  final String loginEmail;
  final ThemeMode currentMode;

  bool get isDarkMode => currentMode == ThemeMode.dark;

  AppSettings copyWith({ThemeMode? currentMode}) {
    return AppSettings(
      loginUserName: loginUserName,
      loginEmail: loginEmail,
      currentMode: currentMode ?? this.currentMode,
    );
  }
}

final selectBaseMenuIndexProvider = StateProvider<int>((_) => BaseMenu.homeIndex);
