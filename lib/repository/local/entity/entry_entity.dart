import 'package:hive_flutter/hive_flutter.dart';

part 'entry_entity.g.dart';

@HiveType(typeId: 1)
class EntryEntity {
  EntryEntity({
    required this.id,
    required this.title,
    this.url,
    required this.mainTagId,
    required this.tagIds,
    required this.note,
    required this.createAt,
    required this.updateAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? url;

  @HiveField(3)
  final String mainTagId;

  @HiveField(4)
  final List<String> tagIds;

  @HiveField(5)
  final String note;

  @HiveField(6)
  final DateTime createAt;

  @HiveField(7)
  final DateTime updateAt;

  static const String boxName = 'entries';
}
