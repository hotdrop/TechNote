import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/repository/local/tag_dao.dart';
import 'package:tech_note/repository/remote/tag_api.dart';

final tagRepositoryProvider = Provider((ref) => TagRepository(ref));

class TagRepository {
  const TagRepository(this._ref);

  final Ref _ref;

  Future<List<Tag>> findAll() async {
    return await _ref.read(tagDaoProvider).findAll();
  }

  Future<int> getRefreshCount() async {
    return await _ref.read(tagApiProvider).getUpdateCount();
  }

  Future<void> refresh() async {
    final newTags = await _ref.read(tagApiProvider).findTags();
    await _ref.read(tagDaoProvider).refresh(newTags);
  }

  Future<Tag> save(Tag tag, Uint8List? imageBytes) async {
    Tag localTag = tag;
    if (imageBytes != null) {
      final imageUrl = await _ref.read(tagApiProvider).saveImage(tag.name, imageBytes);
      localTag = tag.copyThumbnailUrl(imageUrl);
    }

    final id = await _ref.read(tagApiProvider).save(localTag);
    if (tag.isUnregistered()) {
      localTag = localTag.copyId(id);
    }

    _ref.read(tagDaoProvider).save(localTag);

    return localTag;
  }
}
