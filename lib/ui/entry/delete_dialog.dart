import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/ui/entry/entry_page_controller.dart';
import 'package:tech_note/ui/widgets/app_button.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class DeleteDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => const _AlertDialogWrapper(),
        ) ??
        false;
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
            AppText.error('Delete this entry!\nIs it OK?\n\n(Once deleted, it cannot be restored)'),
            const SizedBox(height: 24),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: AppText.normal('Cancel'),
        ),
        const SizedBox(width: 24),
        LoadingButton(
            label: 'Delete',
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(entryPageControllerProvider.notifier).delete();
              Future<void>.delayed(const Duration(seconds: 1)).then((_) {
                navigator.pop(true);
              });
            }),
      ],
    );
  }
}
