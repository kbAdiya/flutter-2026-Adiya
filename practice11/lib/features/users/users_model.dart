import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  final UserRepository _repo;

  UsersModel(this._repo);

  List<User> items = const [];

  ApiException? error;

  bool loading = false;

  bool saving = false;
  ApiException? saveError;

  Future<void> load() async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(String name, String username, String email) async {
    if (saving) {
      return false;
    }

    if (items.isEmpty) {
      return false;
    }

    saving = true;
    saveError = null;
    notifyListeners();

    try {
      final User template = items.first;

      final User draft = User(
        id: 0,
        name: name,
        username: username,
        email: email,
        phone: template.phone,
        website: template.website,
        address: template.address,
        company: template.company,
        companyBs: template.companyBs,
      );

      final User createdUser = await _repo.create(draft);

      items = [createdUser, ...items];

      notifyListeners();

      return true;
    } on ApiException catch (e) {
      saveError = e;
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
