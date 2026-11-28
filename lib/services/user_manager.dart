import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../repositories/user_repository.dart';

class UserManager extends ChangeNotifier {
  final UserRepository _repository;

  UserManager(this._repository);

  UserProfile? _profile;
  bool _isLoading = false;
  bool _isSaving = false;
  Object? _error;

  UserProfile? get profile => _profile;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  Object? get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _repository.getProfile();
    } catch (error, stackTrace) {
      _error = error;

      debugPrint('Failed to load user profile: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.saveProfile(profile);
      _profile = profile;
    } catch (error, stackTrace) {
      _error = error;

      debugPrint('Failed to save user profile: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}