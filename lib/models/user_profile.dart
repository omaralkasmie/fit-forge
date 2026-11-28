const Object _unset = Object();

class UserProfile {
  final String id;
  final String name;
  final String? email;
  final int? age;
  final double? weight;
  final double? height;
  final String? fitnessGoal;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.age,
    this.weight,
    this.height,
    this.fitnessGoal,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
  String? name,
  Object? email = _unset,
  Object? age = _unset,
  Object? weight = _unset,
  Object? height = _unset,
  Object? fitnessGoal = _unset,
  Object? gender = _unset,
  DateTime? updatedAt,
}) {
  return UserProfile(
    id: id,
    name: name ?? this.name,
    email: identical(email, _unset) ? this.email : email as String?,
    age: identical(age, _unset) ? this.age : age as int?,
    weight: identical(weight, _unset) ? this.weight : weight as double?,
    height: identical(height, _unset) ? this.height : height as double?,
    fitnessGoal: identical(fitnessGoal, _unset)
        ? this.fitnessGoal
        : fitnessGoal as String?,
    gender: identical(gender, _unset) ? this.gender : gender as String?,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
}