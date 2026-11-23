import 'package:flutter/foundation.dart';

import '../data/programs/default_programs.dart';
import '../models/training_program.dart';
import '../repositories/training_program_repository.dart';

class TrainingProgramManager extends ChangeNotifier {
  Object? _loadError;

  final TrainingProgramRepository _repository;

  TrainingProgramManager(this._repository);

  List<TrainingProgram> _programs = [];

  bool _isLoading = false;

  List<TrainingProgram> get programs => List.unmodifiable(_programs);

  bool get isLoading => _isLoading;

  Object? get loadError => _loadError;

  Future<void> loadPrograms() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final savedPrograms = await _repository.getSavedPrograms();

      final modifiedPrograms = savedPrograms
          .where((program) => program.type == ProgramType.modified)
          .toList();

      final customPrograms = savedPrograms
          .where((program) => program.type == ProgramType.custom)
          .toList();

      final mergedPrograms = defaultPrograms.map((original) {
        final modified = modifiedPrograms.where(
          (program) => program.sourceProgramId == original.id,
        );

        return modified.isNotEmpty ? modified.first : original;
      }).toList();

      _programs = [...mergedPrograms, ...customPrograms];
    } catch (error, stackTrace) {
      _loadError = error;

      debugPrint('Failed to load training programs: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProgram(TrainingProgram program) async {
    await _repository.saveProgram(program);
    await loadPrograms();
  }

  Future<void> deleteProgram(String programId) async {
    final program = _programs.where((item) => item.id == programId);

    if (program.isEmpty || program.first.type != ProgramType.custom) {
      return;
    }

    await _repository.deleteProgram(programId);
    await loadPrograms();
  }
  Future<void> resetToOriginal(String originalProgramId) async {
  final savedPrograms = await _repository.getSavedPrograms();

  final modifiedPrograms = savedPrograms.where(
    (program) =>
        program.type == ProgramType.modified &&
        program.sourceProgramId == originalProgramId,
  ).toList();

  if (modifiedPrograms.isEmpty) return;

  for (final program in modifiedPrograms) {
    await _repository.deleteProgram(program.id);
  }

  await loadPrograms();
}
}
