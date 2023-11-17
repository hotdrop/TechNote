import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_logger.dart';
import 'package:tech_note/repository/remote/firestore_helper.dart';
import 'package:tech_note/model/tag.dart';

final tagApiProvider = Provider<_TagApi>((ref) => const _TagApi());

class _TagApi {
  const _TagApi();

  static const String _colRoot = 'TechNote';
  static const String _docRoot = 'TechTag';
  static const String _colTags = 'Tags';

  Future<List<Tag>> findTags() async {
    final snapshot = await FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colTags).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return Tag(
        id: doc.id,
        name: FirestoreHelper.getString(map, 'name'),
        thumbnailUrl: FirestoreHelper.getString(map, 'thumbnailUrl'),
        color: Tag.hexToColor(FirestoreHelper.getString(map, 'color')),
        isTextColorBlack: FirestoreHelper.getBool(map, 'isTextColorBlack'),
        tagArea: Tag.indexToTagAreaEnum(FirestoreHelper.getInt(map, 'area')),
      );
    }).toList();
  }

  Future<int> getUpdateTagCount() async {
    final snapshot = await FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colTags).count().get();
    return snapshot.count;
  }

  Future<String> save(Tag tag) async {
    final tagCollectionRef = FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colTags);
    final docRef = (tag.isUnregistered()) ? tagCollectionRef.doc() : tagCollectionRef.doc(tag.id);

    await docRef.set({
      'name': tag.name,
      'thumbnailUrl': tag.thumbnailUrl,
      'color': tag.toStringColorHex(),
      'isTextColorBlack': tag.isTextColorBlack,
      'area': tag.tagArea.index,
    }, SetOptions(merge: true));

    AppLogger.d('Tag情報をFirestoreに保存します。元のID=${tag.id} refID=${docRef.id}');

    return docRef.id;
  }

  Future<String> saveImage(String name, Uint8List imageBytes) async {
    final storageRef = FirebaseStorage.instance.ref().child('$name.png');
    final snapshot = await storageRef.putData(imageBytes);
    return await snapshot.ref.getDownloadURL();
  }
}
