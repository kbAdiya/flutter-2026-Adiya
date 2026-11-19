import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'user.dart';

class UsersCache {
  Future<File> _getCacheFile() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/users.json');

    return file;
  }

  Future<void> save(List<User> users) async {
    final file = await _getCacheFile();

    final List<Map<String, dynamic>> usersJson = [];

    for (final user in users) {
      usersJson.add(user.toJson());
    }

    final String jsonString = jsonEncode(usersJson);

    await file.writeAsString(jsonString);
  }

  Future<List<User>?> load() async {
    final file = await _getCacheFile();

    final bool fileExists = await file.exists();

    if (!fileExists) {
      return null;
    }

    final String jsonString = await file.readAsString();

    final List<dynamic> usersJson = jsonDecode(jsonString) as List<dynamic>;

    final List<User> users = [];

    for (final item in usersJson) {
      final userJson = item as Map<String, dynamic>;

      final user = User.fromJson(userJson);

      users.add(user);
    }

    return users;
  }
}
