import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tech_note/ui/info/information_page_controller.dart';
import 'package:tech_note/ui/widgets/app_button.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class RefreshDialog {
  const RefreshDialog._({
    required this.label,
    required this.onRefresh,
    required this.isRefreshEntry,
  });

  final String label;
  final Future<void> Function() onRefresh;
  final bool isRefreshEntry;

  factory RefreshDialog.entry({
    required String label,
    required Future<void> Function() onRefresh,
  }) {
    return RefreshDialog._(label: label, onRefresh: onRefresh, isRefreshEntry: true);
  }

  factory RefreshDialog.tag({
    required String label,
    required Future<void> Function() onRefresh,
  }) {
    return RefreshDialog._(label: label, onRefresh: onRefresh, isRefreshEntry: false);
  }

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _AlertDialogWrapper(label, onRefresh, isRefreshEntry),
    );
  }
}

class _AlertDialogWrapper extends StatelessWidget {
  const _AlertDialogWrapper(this.label, this.onRefresh, this.isRefreshEntry);

  final String label;
  final Future<void> Function() onRefresh;
  final bool isRefreshEntry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.normal(label),
            const SizedBox(height: 8),
            _ViewDataCountLabels(isRefreshEntry),
            const SizedBox(height: 24),
            _ActionButtons(onRefresh),
          ],
        ),
      ),
    );
  }
}

class _ViewDataCountLabels extends ConsumerWidget {
  const _ViewDataCountLabels(this.isRefreshEntry);

  final bool isRefreshEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isRefreshEntry) {
      return ref.watch(infoPageRefreshEntryCountProvider).when(
            data: (data) => AppText.normal('- Number of update Entry: $data'),
            error: (e, s) => AppText.error('Error! $e'),
            loading: () => const _ViewLoadingDataCountLabel(),
          );
    } else {
      return ref.watch(infoPageRefreshTagCountProvider).when(
            data: (data) => AppText.normal('- Number of update Tag: $data'),
            error: (e, s) => AppText.error('Error! $e'),
            loading: () => const _ViewLoadingDataCountLabel(),
          );
    }
  }
}

class _ViewLoadingDataCountLabel extends StatelessWidget {
  const _ViewLoadingDataCountLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText.normal('Now Loading', color: Theme.of(context).primaryColor),
        const SizedBox(width: 16),
        LoadingAnimationWidget.prograssiveDots(color: Theme.of(context).primaryColor, size: 30),
      ],
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons(this.onRefresh);

  final Future<void> Function() onRefresh;

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
        LoadingButton(
            label: 'Refresh',
            onPressed: () async {
              final navigator = Navigator.of(context);
              await onRefresh();
              Future<void>.delayed(const Duration(seconds: 1)).then((_) {
                navigator.pop();
              });
            }),
      ],
    );
  }
}
