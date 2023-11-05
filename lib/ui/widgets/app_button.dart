import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({super.key, required this.width, required this.enable, required this.onPressed});

  final bool enable;
  final double width;
  final Future<void> Function() onPressed;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  final _controller = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: RoundedLoadingButton(
        onPressed: widget.enable
            ? () async {
                await widget.onPressed();
                _controller.success();
              }
            : null,
        controller: _controller,
        color: AppTheme.primaryLightColor,
        child: AppText.normal('Save'),
      ),
    );
  }
}
