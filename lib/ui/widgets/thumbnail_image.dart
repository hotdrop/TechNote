import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage._(this.imageUrl, this.size, this.isCircle);

  factory ThumbnailImage.tag({String? imageUrl}) {
    return ThumbnailImage._(imageUrl, 30, true);
  }

  factory ThumbnailImage.entry({String? imageUrl}) {
    return ThumbnailImage._(imageUrl, 100, false);
  }

  final String? imageUrl;
  final double size;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      const defaultImage = Icon(Tag.defaultIcon);
      return isCircle ? const CircleAvatar(child: defaultImage) : defaultImage;
    }

    ImageNetwork imageNetwork = ImageNetwork(
      image: imageUrl!,
      imageCache: FastCachedImageProvider(imageUrl!),
      height: size,
      width: size,
      onLoading: const CircularProgressIndicator(
        color: AppTheme.primaryColor,
      ),
    );

    return isCircle ? ClipOval(child: imageNetwork) : imageNetwork;
  }
}
