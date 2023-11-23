import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/common/app_logger.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/repository/remote/firestore_helper.dart';

final entryApiProvider = Provider<_EntryAPI>((ref) => const _EntryAPI());

class _EntryAPI {
  const _EntryAPI();

  static const String _colRoot = 'TechNote';
  static const String _docRoot = 'TechEntry';
  static const String _colEntries = 'Entries';

  Future<List<Entry>> findEntires(DateTime? lastUpdateAt) async {
    final ref = FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colEntries);
    final snapshot = (lastUpdateAt != null) ? await ref.where('updateAt', isGreaterThan: lastUpdateAt).get() : await ref.get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      final urlForFirestore = FirestoreHelper.getString(map, 'url');
      return Entry(
        id: doc.id,
        title: FirestoreHelper.getString(map, 'title'),
        url: urlForFirestore.isNotEmpty ? urlForFirestore : null,
        mainTagId: FirestoreHelper.getString(map, 'mainTagId'),
        tagIds: FirestoreHelper.getStringList(map, 'tagIds'),
        note: FirestoreHelper.getString(map, 'note'),
        createAt: FirestoreHelper.getDateTime(map, 'createAt')!,
        updateAt: FirestoreHelper.getDateTime(map, 'updateAt')!,
      );
    }).toList();
  }

  Future<int> getUpdateCount(DateTime? lastUpdateAt) async {
    final snapshot = await FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colEntries).count().get();
    return snapshot.count;
  }

  Future<String> save(Entry entry) async {
    final colRef = FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colEntries);
    final docRef = (entry.isUnregistered()) ? colRef.doc() : colRef.doc(entry.id);

    await docRef.set({
      'title': entry.title,
      'url': entry.url ?? '',
      'mainTagId': entry.mainTagId,
      'tagIds': entry.tagIds.join(FirestoreHelper.tagIdSeparator),
      'note': entry.note,
      'createAt': Timestamp.fromDate(entry.createAt),
      'updateAt': Timestamp.fromDate(entry.updateAt),
    }, SetOptions(merge: true));

    AppLogger.d('Tag情報をFirestoreに保存します。元のID=${entry.id} refID=${docRef.id}');

    return docRef.id;
  }

  Future<void> delete(Entry entry) async {
    // TODO
  }
}
