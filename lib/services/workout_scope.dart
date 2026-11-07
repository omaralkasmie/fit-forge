import 'package:flutter/widgets.dart';

import 'workout_manager.dart';

class WorkoutScope extends InheritedNotifier<WorkoutManager> {
  const WorkoutScope({
    super.key,
    required WorkoutManager notifier,
    required super.child,
  }) : super(notifier: notifier);

  static WorkoutManager of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WorkoutScope>();

    assert(scope != null, 'WorkoutScope not found in widget tree');

    return scope!.notifier!;
  }
}
