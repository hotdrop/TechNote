import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/repository/local/entity/tag_entity.dart';

final tagDaoProvider = Provider((ref) => const TagDao());

class TagDao {
  const TagDao();

  Future<List<Tag>> findAll() async {
    final box = await Hive.openBox<TagEntity>(TagEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    final entities = box.values;
    return entities
        .map((entity) => Tag(
              id: entity.id,
              name: entity.name,
              thumbnailUrl: entity.thumbnailUrl,
              color: Tag.hexToColor(entity.colorHex),
              isTextColorBlack: entity.isTextColorBlack,
              tagArea: Tag.indexToTagAreaEnum(entity.tagAreaIndex),
            ))
        .toList();
  }

  Future<void> refresh(List<Tag> tags) async {
    final entities = tags
        .map((tag) => TagEntity(
              id: tag.id,
              name: tag.name,
              thumbnailUrl: tag.thumbnailUrl,
              colorHex: tag.toStringColorHex(),
              isTextColorBlack: tag.isTextColorBlack,
              tagAreaIndex: tag.tagArea.index,
            ))
        .toList();

    final box = await Hive.openBox<TagEntity>(TagEntity.boxName);
    await box.clear();
    await box.addAll(entities);
  }

  Future<void> save(Tag tag) async {
    final entity = TagEntity(
      id: tag.id,
      name: tag.name,
      thumbnailUrl: tag.thumbnailUrl,
      colorHex: tag.toStringColorHex(),
      isTextColorBlack: tag.isTextColorBlack,
      tagAreaIndex: tag.tagArea.index,
    );
    final box = await Hive.openBox<TagEntity>(TagEntity.boxName);
    await box.put(entity.id, entity);
  }
}
