import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/repository/local/shared_prefs.dart';

final appSettingsRepositoryProvider = Provider((ref) => _AppSettingRepository(ref));

class _AppSettingRepository {
  _AppSettingRepository(this._ref);

  final Ref _ref;

  Future<bool> isDarkMode() async {
    return await _ref.read(sharedPrefsProvider).isDarkMode();
  }

  Future<void> changeDarkMode() async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(true);
  }

  Future<void> changeLightMode() async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(false);
  }

  Future<User?> signInWithGoogle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@gmail.com',
    });
    final credential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    return credential.user;
  }
}
