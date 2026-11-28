import 'package:drift/drift.dart' as drift;

import '../data/local/app_database.dart' as db;
import '../models/user_profile.dart';

class UserRepository {
  final db.AppDatabase _database;

  UserRepository(this._database);

  Future<UserProfile?> getProfile() async {
    final query = _database.select(_database.userProfiles)..limit(1);

    final result = await query.getSingleOrNull();

    if (result == null) return null;

    return _toModel(result);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final companion = db.UserProfilesCompanion.insert(
      id: profile.id,
      name: profile.name,
      email: drift.Value(profile.email),
      age: drift.Value(profile.age),
      weight: drift.Value(profile.weight),
      height: drift.Value(profile.height),
      fitnessGoal: drift.Value(profile.fitnessGoal),
      gender: drift.Value(profile.gender),
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );

    await _database.into(_database.userProfiles).insertOnConflictUpdate(
      companion,
    );
  }

  UserProfile _toModel(db.UserProfile data) {
    return UserProfile(
      id: data.id,
      name: data.name,
      email: data.email,
      age: data.age,
      weight: data.weight,
      height: data.height,
      fitnessGoal: data.fitnessGoal,
      gender: data.gender,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}