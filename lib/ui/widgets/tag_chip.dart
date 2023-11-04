import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag, required this.isSelected, required this.onSelected});

  final Tag tag;
  final bool isSelected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: _thumbnailImage(),
      label: AppText.normal(tag.name, color: tag.isTextColorBlack ? Colors.black : Colors.white),
      backgroundColor: Theme.of(context).disabledColor,
      selectedColor: tag.color,
      selected: true,
      onSelected: onSelected,
    );
  }

  Widget _thumbnailImage() {
    final url = tag.thumbnailUrl;
    if (url != null) {
      return ClipOval(
        child: ImageNetwork(
          image: url,
          imageCache: FastCachedImageProvider(url),
          height: 30,
          width: 30,
          onLoading: const CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );
    } else {
      return const CircleAvatar(child: Icon(Tag.defaultIcon));
    }
  }
}
