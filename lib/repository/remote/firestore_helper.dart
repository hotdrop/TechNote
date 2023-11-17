class FirestoreHelper {
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
}
