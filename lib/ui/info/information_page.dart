import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/app_settings.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/info/refresh_dialog.dart';
import 'package:tech_note/ui/info/information_page_controller.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class InformationPage extends ConsumerWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.pageTitle(AppTheme.appName),
      ),
      body: ref.watch(informationPageControllerProvider).when(
            data: (data) => _ViewBody(data),
            error: (err, st) => _ViewOnLoading(errorMessage: '$err'),
            loading: () => const _ViewOnLoading(),
          ),
    );
  }
}

class _ViewOnLoading extends StatelessWidget {
  const _ViewOnLoading({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Center(
        child: AppText.error(errorMessage!),
      );
    }

    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).primaryColor, size: 32),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.packageInfo);

  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ViewAccountInfo(),
          _ViewVersion(packageInfo.version),
          const _ViewEntryDataLabel(),
          const _ViewTagDataLabel(),
          const _RowThemeSwitch(),
          const SizedBox(height: 8),
          _ViewLicense(packageInfo),
        ],
      ),
    );
  }
}

class _ViewAccountInfo extends ConsumerWidget {
  const _ViewAccountInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSetting = ref.watch(appSettingsNotifierProvider);
    return ListTile(
      leading: const Icon(
        Icons.account_circle,
        size: 32,
      ),
      title: AppText.normal(appSetting.loginEmail),
      subtitle: AppText.normal(appSetting.loginUserName),
    );
  }
}

class _ViewVersion extends StatelessWidget {
  const _ViewVersion(this.version);

  final String version;

  @override
  Widget build(BuildContext context) {
    return _RowItem(
      iconData: Icons.info_rounded,
      label: 'Version:',
      trailing: AppText.normal(version),
    );
  }
}

class _ViewEntryDataLabel extends ConsumerWidget {
  const _ViewEntryDataLabel();

  static final _dateFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cnt = ref.watch(entryNotifierProvider).length;
    final lastUpdateAt = ref.watch(lastUpdateEntryDateTimeProvider);
    final lastUpdateAtStr = lastUpdateAt == null ? '-' : _dateFormat.format(lastUpdateAt);
    return _RowItem(
      iconData: Icons.book,
      label: 'Number of EntryData: $cnt',
      subLabel: 'Last latest load data: $lastUpdateAtStr',
      trailing: IconButton(
        onPressed: () async => await _showRefreshDialog(context, ref),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> _showRefreshDialog(BuildContext context, WidgetRef ref) async {
    await RefreshDialog.entry(
      label: 'Refresh the latest data from the server',
      onRefresh: () async {
        await ref.read(informationPageControllerProvider.notifier).refreshEntry();
      },
    ).show(context);
  }
}

class _ViewTagDataLabel extends ConsumerWidget {
  const _ViewTagDataLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cnt = ref.watch(tagNotifierProvider).length;
    return _RowItem(
      iconData: Icons.label,
      label: 'Number of TagData: $cnt',
      trailing: IconButton(
        onPressed: () async => await _showRefreshDialog(context, ref),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> _showRefreshDialog(BuildContext context, WidgetRef ref) async {
    await RefreshDialog.tag(
      label: 'Refresh the latest data from the server',
      onRefresh: () async {
        await ref.read(informationPageControllerProvider.notifier).refreshTag();
      },
    ).show(context);
  }
}

///
/// アプリのテーマを変更するスイッチ
///
class _RowThemeSwitch extends ConsumerWidget {
  const _RowThemeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsNotifierProvider).isDarkMode;
    return _RowItem(
      iconData: isDarkMode ? Icons.dark_mode : Icons.light_mode,
      label: 'Change Theme',
      trailing: Switch(
        value: isDarkMode,
        onChanged: (isDark) async {
          await ref.read(appSettingsNotifierProvider.notifier).setDarkMode(isDark);
        },
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({required this.iconData, required this.label, this.subLabel, this.trailing});

  final IconData iconData;
  final String label;
  final String? subLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(iconData, size: 32),
          const SizedBox(width: 16),
          if (subLabel == null) AppText.normal(label),
          if (subLabel != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.normal(label),
                AppText.small(subLabel!, color: Colors.grey),
              ],
            ),
          const SizedBox(width: 16),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _ViewLicense extends ConsumerWidget {
  const _ViewLicense(this.packageInfo);

  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () async {
        showLicensePage(
          context: context,
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
          applicationIcon: Image.asset('assets/images/ic_launch.png'),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('License'),
      ),
    );
  }
}
