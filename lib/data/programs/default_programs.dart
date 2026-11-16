import '../../models/training_program.dart';
import '../../models/program_exercise.dart';
import '../../models/program_set.dart';

const List<TrainingProgram> defaultPrograms = [
  TrainingProgram(
    id: 'muscle_building',
    exercises: [
  ProgramExercise(
    exerciseId: 'chest_001',
    exerciseOrder: 1,
    sets: [
      ProgramSet(setNumber: 1, targetReps: 10),
      ProgramSet(setNumber: 2, targetReps: 10),
      ProgramSet(setNumber: 3, targetReps: 10),
    ],
  ),
  ProgramExercise(
  exerciseId: 'chest_002',
  exerciseOrder: 2,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 10),
    ProgramSet(setNumber: 2, targetReps: 10),
    ProgramSet(setNumber: 3, targetReps: 10),
  ],
),
ProgramExercise(
  exerciseId: 'chest_003',
  exerciseOrder: 3,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 10),
    ProgramSet(setNumber: 2, targetReps: 10),
    ProgramSet(setNumber: 3, targetReps: 10),
  ],
),
ProgramExercise(
  exerciseId: 'back_003',
  exerciseOrder: 4,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 10),
    ProgramSet(setNumber: 2, targetReps: 10),
    ProgramSet(setNumber: 3, targetReps: 10),
  ],
),
ProgramExercise(
  exerciseId: 'back_001',
  exerciseOrder: 5,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 12),
    ProgramSet(setNumber: 2, targetReps: 12),
    ProgramSet(setNumber: 3, targetReps: 12),
  ],
),
ProgramExercise(
  exerciseId: 'shoulder_001',
  exerciseOrder: 6,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 10),
    ProgramSet(setNumber: 2, targetReps: 10),
    ProgramSet(setNumber: 3, targetReps: 10),
  ],
),
ProgramExercise(
  exerciseId: 'shoulder_002',
  exerciseOrder: 7,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 12),
    ProgramSet(setNumber: 2, targetReps: 12),
    ProgramSet(setNumber: 3, targetReps: 12),
  ],
),
ProgramExercise(
  exerciseId: 'leg_001',
  exerciseOrder: 8,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 10),
    ProgramSet(setNumber: 2, targetReps: 10),
    ProgramSet(setNumber: 3, targetReps: 10),
  ],
),
ProgramExercise(
  exerciseId: 'leg_002',
  exerciseOrder: 9,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 12),
    ProgramSet(setNumber: 2, targetReps: 12),
    ProgramSet(setNumber: 3, targetReps: 12),
  ],
),
ProgramExercise(
  exerciseId: 'arms_001',
  exerciseOrder: 10,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 12),
    ProgramSet(setNumber: 2, targetReps: 12),
    ProgramSet(setNumber: 3, targetReps: 12),
  ],
),
ProgramExercise(
  exerciseId: 'arms_004',
  exerciseOrder: 11,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 12),
    ProgramSet(setNumber: 2, targetReps: 12),
    ProgramSet(setNumber: 3, targetReps: 12),
  ],
),
ProgramExercise(
  exerciseId: 'abs_001',
  exerciseOrder: 12,
  sets: [
    ProgramSet(setNumber: 1, targetReps: 15),
    ProgramSet(setNumber: 2, targetReps: 15),
    ProgramSet(setNumber: 3, targetReps: 15),
  ],
),
],
    nameAr: 'بناء العضلات',
    nameEn: 'Muscle Building',
    descriptionAr: 'برنامج متكامل لزيادة الكتلة العضلية وتحسين القوة البدنية.',
    descriptionEn: 'A complete program to increase muscle mass and improve strength.',
    durationWeeks: 4,
    levelAr: 'متوسط',
    levelEn: 'Intermediate',
    category: 1,
    type: ProgramType.builtIn,
  ),
  TrainingProgram(
    id: 'fat_burning',
    nameAr: 'حرق الدهون',
    nameEn: 'Fat Burning',
    descriptionAr: 'برنامج فعال لحرق السعرات الحرارية وتقليل نسبة الدهون.',
    descriptionEn: 'An effective program to burn calories and reduce body fat.',
    durationWeeks: 3,
    levelAr: 'مبتدئ',
    levelEn: 'Beginner',
    category: 2,
    type: ProgramType.builtIn,
  ),
  TrainingProgram(
    id: 'general_fitness',
    nameAr: 'اللياقة العامة',
    nameEn: 'General Fitness',
    descriptionAr: 'تحسين اللياقة البدنية والصحة العامة وزيادة النشاط اليومي.',
    descriptionEn: 'Improve fitness, overall health, and daily activity.',
    durationWeeks: 4,
    levelAr: 'مبتدئ',
    levelEn: 'Beginner',
    category: 3,
    type: ProgramType.builtIn,
  ),
  TrainingProgram(
    id: 'advanced_program',
    nameAr: 'برنامج متقدم',
    nameEn: 'Advanced Program',
    descriptionAr: 'تحدٍّ أقوى للمتمرنين لتحقيق أفضل النتائج.',
    descriptionEn: 'A tougher challenge for experienced athletes to achieve better results.',
    durationWeeks: 8,
    levelAr: 'متقدم',
    levelEn: 'Advanced',
    category: 1,
    type: ProgramType.builtIn,
  ),
];