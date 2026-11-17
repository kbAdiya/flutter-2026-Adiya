import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  final ApiClient _api;

  UserRepository(this._api);

  Future<List<User>> getAll() async {
    try {
      final dynamic data = await _api.get('/users');

      final List<dynamic> usersJson = data as List<dynamic>;

      final List<User> users = [];

      for (final item in usersJson) {
        final Map<String, dynamic> userJson = item as Map<String, dynamic>;

        final User user = User.fromJson(userJson);

        users.add(user);
      }

      return users;
    } on ApiException {
      rethrow;
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    try {
      final dynamic data = await _api.get('/users/$id');

      final Map<String, dynamic> userJson = data as Map<String, dynamic>;

      final User user = User.fromJson(userJson);

      return user;
    } on ApiException {
      rethrow;
    } on TypeError catch (e) {
      throw BadResponseException('users/$id: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    try {
      final dynamic data = await _api.post('/users', draft.toJson());

      final Map<String, dynamic> userJson = data as Map<String, dynamic>;

      final User createdUser = User.fromJson(userJson);

      return createdUser;
    } on ApiException {
      rethrow;
    } on TypeError catch (e) {
      throw BadResponseException('create user: $e');
    } on FormatException catch (e) {
      throw BadResponseException('create user: $e');
    }
  }
}
