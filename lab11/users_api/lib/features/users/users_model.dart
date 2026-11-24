import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';

import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repository);

  final UserRepository _repository;

  List<User> items = [];

  ApiException? error;

  bool loading = false;
  bool saving = false;
  bool fromCache = false;

  Future<void> load() async {
    if (loading) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _repository.getAll();

      items = result.items;
      fromCache = result.fromCache;
    } on ApiException catch (e) {
      error = e;
    } catch (_) {
      error = const BadResponseException('Could not read or save data');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<ApiException?> addUser(User draft) async {
    if (saving) return null;

    saving = true;
    notifyListeners();

    try {
      final created = await _repository.create(draft);

      items = [created, ...items];

      return null;
    } on ApiException catch (e) {
      return e;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
