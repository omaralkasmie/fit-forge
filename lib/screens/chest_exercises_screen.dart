import 'package:flutter/material.dart';

import '../data/exercises/chest_exercises.dart';
import '../l10n/app_localizations.dart';
import 'muscle_group_exercises_screen.dart';

class ChestExercisesScreen extends StatelessWidget {
  const ChestExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MuscleGroupExercisesScreen(
      title: l10n.chestScreenTitle,
      bannerTitle: l10n.chestBannerTitle,
      bannerSubtitle: l10n.chestBannerSubtitle,
      exercises: chestExercises,
    );
  }
}
