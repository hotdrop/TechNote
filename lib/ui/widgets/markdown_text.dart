import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: note,
      selectable: true,
      shrinkWrap: true,
      builders: {
        'code': _CodeElementBuilder(),
      },
    );
  }
}

class _CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String? codeClass = element.attributes['class'];
    if (codeClass == null) {
      return AppText.normal(element.textContent, color: Colors.orange);
    }

    final lang = codeClass.substring(9);
    return Column(
      children: [
        _HeaderWidget(language: lang, textContents: element.textContent),
        _ContentsWidget(language: lang, textContents: element.textContent),
      ],
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({required this.language, required this.textContents});

  final String language;
  final String textContents;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: AppText.normal(language),
        ),
        IconButton(
          onPressed: () {
            final t = ClipboardData(text: textContents);
            Clipboard.setData(t);
          },
          tooltip: 'クリップボードにコピーします',
          icon: const Icon(Icons.content_copy),
        ),
      ],
    );
  }
}

class _ContentsWidget extends StatelessWidget {
  const _ContentsWidget({required this.language, required this.textContents});

  final String language;
  final String textContents;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: HighlightView(
        textContents,
        language: language,
        padding: const EdgeInsets.all(8),
        theme: atomOneDarkTheme,
        textStyle: const TextStyle(fontSize: AppTheme.defaultTextSize),
      ),
    );
  }
}
