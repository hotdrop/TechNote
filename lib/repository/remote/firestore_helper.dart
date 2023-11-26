import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static const String tagIdSeparator = ',';

  static String getString(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is String) {
      return fieldVal;
    } else {
      return '';
    }
  }

  static bool getBool(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is bool) {
      return fieldVal;
    } else {
      return false;
    }
  }

  static int getInt(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is int) {
      return fieldVal;
    } else {
      return 0;
    }
  }

  static List<String> getStringList(Map<String, dynamic>? map, String fieldName) {
    // フィールドが存在しない場合は空のリストを返す
    if (map == null || !map.containsKey(fieldName) || map[fieldName] == null) {
      return [];
    }

    final String fieldVal = map[fieldName];

    if (fieldVal.contains(tagIdSeparator)) {
      return fieldVal.split(tagIdSeparator).map((e) => e.trim()).toList();
    } else {
      return [fieldVal];
    }
  }

  static DateTime? getDateTime(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is Timestamp) {
      return fieldVal.toDate();
    } else {
      return null;
    }
  }
}
