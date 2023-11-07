import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/info/information_page_controller.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class InformationPage extends ConsumerWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTheme.appName),
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
          const SizedBox(height: 8),
          AppText.normal('Version: ${packageInfo.version}'),
          const SizedBox(height: 8),
          _ViewLicense(packageInfo),
          const SizedBox(height: 8),
          const _ViewDataCountLabel(),
        ],
      ),
    );
  }
}

class _ViewAccountInfo extends ConsumerWidget {
  const _ViewAccountInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO アカウント情報を取得する
    return ListTile(
      leading: const Icon(
        Icons.account_circle,
        size: 32,
      ),
      title: AppText.normal('Google Account'),
      subtitle: AppText.normal('sample.dummy@example.com'),
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
          // applicationIcon: Image.asset('assets/images/ic_app.png'), // TODO アプリアイコンを設定する
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('License'),
      ),
    );
  }
}

class _ViewDataCountLabel extends ConsumerWidget {
  const _ViewDataCountLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryDataCnt = ref.watch(entryNotifierProvider).length;
    final tagDataCnt = ref.watch(tagNotifierProvider).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.normal('[Local hold data]', isBold: true),
        AppText.normal('  - Number of EntryData: $entryDataCnt'),
        AppText.normal('  - Number of TagData: $tagDataCnt'),
      ],
    );
  }
}
