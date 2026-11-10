import 'program_exercise.dart';

enum ProgramType {
  builtIn,
  custom,
  modified,
}

class TrainingProgram {
  final String id;

  final String nameAr;
  final String nameEn;

  final String descriptionAr;
  final String descriptionEn;

  final int durationWeeks;

  final String levelAr;
  final String levelEn;

  final int category;
  final ProgramType type;

  // معرف البرنامج الأصلي عند تعديل برنامج جاهز.
  final String? sourceProgramId;

  final List<ProgramExercise> exercises;

  const TrainingProgram({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.durationWeeks,
    required this.levelAr,
    required this.levelEn,
    required this.category,
    required this.type,
    this.sourceProgramId,
    this.exercises = const [],
  });

  String nameFor(bool isArabic) =>
      isArabic ? nameAr : nameEn;

  String descriptionFor(bool isArabic) =>
      isArabic ? descriptionAr : descriptionEn;

  String levelFor(bool isArabic) =>
      isArabic ? levelAr : levelEn;
}