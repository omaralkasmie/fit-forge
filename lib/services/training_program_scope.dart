import 'package:flutter/widgets.dart';

import 'training_program_manager.dart';

class TrainingProgramScope
    extends InheritedNotifier<TrainingProgramManager> {
  const TrainingProgramScope({
    super.key,
    required TrainingProgramManager notifier,
    required super.child,
  }) : super(notifier: notifier);

  static TrainingProgramManager of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<TrainingProgramScope>();

    assert(
      scope != null,
      'TrainingProgramScope not found in widget tree',
    );

    return scope!.notifier!;
  }
}