import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage._(this.imageUrl, this.size, this.isCircle);

  factory ThumbnailImage.tag({String? imageUrl}) {
    return ThumbnailImage._(imageUrl, 30, true);
  }

  factory ThumbnailImage.entryCard({String? imageUrl}) {
    return ThumbnailImage._(imageUrl, 50, false);
  }

  factory ThumbnailImage.entryPage({String? imageUrl}) {
    return ThumbnailImage._(imageUrl, 75, false);
  }

  final String? imageUrl;
  final double size;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    if (isCircle) {
      return _ShapeCircle(url: imageUrl, size: size);
    } else {
      return _ShapeRectangle(url: imageUrl, size: size);
    }
  }
}

class _ShapeCircle extends StatelessWidget {
  const _ShapeCircle({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const CircleAvatar(child: Icon(Tag.defaultIcon));
    } else {
      return ClipOval(
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: _ThumbnailForNetworkImage(
              url: url!,
              size: size,
            )),
      );
    }
  }
}

class _ShapeRectangle extends StatelessWidget {
  const _ShapeRectangle({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        shape: BoxShape.rectangle,
      ),
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: (url == null) ? const Icon(Tag.defaultIcon) : _ThumbnailForNetworkImage(url: url!, size: size),
        ),
      ),
    );
  }
}

class _ThumbnailForNetworkImage extends StatelessWidget {
  const _ThumbnailForNetworkImage({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      key: ValueKey(url),
      height: size,
      width: size,
      cacheWidth: 75,
      cacheHeight: 75,
    );
  }
}
