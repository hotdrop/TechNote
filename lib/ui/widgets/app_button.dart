import 'package:flutter/material.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.enable, required this.onPressed});

  final bool enable;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: enable ? onPressed : null,
      icon: const Icon(Icons.save),
      label: AppText.normal('Save'),
    );
  }
}
