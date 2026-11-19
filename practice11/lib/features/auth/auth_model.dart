import 'package:flutter/foundation.dart';

import '../../core/storage/secure_store.dart';

class AuthModel extends ChangeNotifier {
  final SecureStore _store;

  String? _token;

  bool loading = false;

  AuthModel(this._store, this._token);

  bool get signedIn {
    return _token != null;
  }

  Future<void> login(String email, String password) async {
    if (loading) {
      return;
    }

    if (password.length < 8) {
      throw ArgumentError('Password must contain at least 8 characters');
    }

    loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final String token = 'tok_${email.hashCode}';

      await _store.saveToken(token);

      _token = token;
      notifyListeners();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _store.clear();

    _token = null;
    notifyListeners();
  }
}
