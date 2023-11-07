import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/ui/home/home_page_controller.dart';
import 'package:tech_note/ui/widgets/app_button.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class RefreshDialog {
  static Future<void> show(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (context) => const _AlertDialogWrapper(),
    );
  }
}

class _AlertDialogWrapper extends StatelessWidget {
  const _AlertDialogWrapper();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.normal('Refresh the latest EntryData and TagData over the network'),
            const SizedBox(height: 8),
            const _ViewDataCountLabels(),
            const SizedBox(height: 24),
            const _Buttons(),
          ],
        ),
      ),
    );
  }
}

class _ViewDataCountLabels extends ConsumerWidget {
  const _ViewDataCountLabels();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(homePageUpdateCountByRefreshProvider).when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.normal('- Number of update EntryData: ${data.$1}'),
            AppText.normal('- Number of update TagData: ${data.$2}'),
          ],
        );
      },
      error: (e, s) {
        return AppText.error('Error! $e');
      },
      loading: () {
        return Row(
          children: [
            AppText.normal(
              'Now Loading',
              color: AppTheme.primaryLightColor,
            ),
            const SizedBox(width: 16),
            LoadingAnimationWidget.prograssiveDots(color: AppTheme.primaryLightColor, size: 30),
          ],
        );
      },
    );
  }
}

class _Buttons extends ConsumerWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText.normal('Cancel'),
        ),
        const SizedBox(width: 24),
        RefreshButton(onPressed: () async {
          final navigator = Navigator.of(context);
          await ref.read(homePageControllerProvider.notifier).refresh();
          Future<void>.delayed(const Duration(seconds: 1)).then((_) {
            navigator.pop();
          });
        }),
      ],
    );
  }
}
