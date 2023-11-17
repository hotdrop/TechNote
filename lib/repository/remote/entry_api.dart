import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/entry.dart';

final entryApiProvider = Provider<_EntryAPI>((ref) => const _EntryAPI());

class _EntryAPI {
  const _EntryAPI();

  static const String _colRoot = 'TechNote';
  static const String _docRoot = 'TechEntry';
  static const String _colEntries = 'Entries';

  Future<List<Entry>> findEntires(DateTime? lastUpdateAt) async {
    // final ref = FirebaseFirestore.instance.collection(_colRoot).doc(_docRoot).collection(_colEntries);
    // final snapshot = (lastUpdateAt != null) ? await ref.where('updateAt', isGreaterThan: lastUpdateAt).get() : await ref.get();
    throw UnimplementedError();
  }
}
