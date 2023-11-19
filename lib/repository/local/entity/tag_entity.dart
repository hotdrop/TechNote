import 'package:hive_flutter/hive_flutter.dart';

part 'tag_entity.g.dart';

@HiveType(typeId: 0)
class TagEntity {
  TagEntity({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.isTextColorBlack,
    required this.tagAreaIndex,
    this.thumbnailUrl,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String colorHex;

  @HiveField(3)
  final bool isTextColorBlack;

  @HiveField(4)
  final int tagAreaIndex;

  @HiveField(5)
  final String? thumbnailUrl;

  static const String boxName = 'tags';
}
