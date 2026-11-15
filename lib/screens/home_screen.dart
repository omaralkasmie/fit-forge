import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes/app_router.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../services/workout_scope.dart';
import '../models/workout_progress_stats.dart';
import '../services/training_program_scope.dart';
import '../models/exercise.dart';
import '../data/workouts/exercise_library.dart';
import '../models/training_cycle_progress.dart';

const Color bgColor = Color(0xFF0B0B16);
const Color cardColor = Color(0xFF15182F);
const Color purpleColor = Color(0xFF9B5CFF);
const Color pinkColor = Color(0xFFE34DFF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TrainingCycleProgress? _cycleProgress;
  WorkoutProgressStats? _stats;
  bool _isLoading = true;

  List<Exercise> _suggestedExercises = [];
  bool _isLoadingExercises = true;
  bool _hasLoadedExercises = false;

  


  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  _loadStats();
  _loadTrainingCycleProgress();

  if (!_hasLoadedExercises) {
    _hasLoadedExercises = true;
    _loadSuggestedExercises();
  }
}

  Future<void> _loadStats() async {
    final manager = WorkoutScope.of(context);
    final now = DateTime.now();

    final stats = await manager.getProgressStats(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 1),
    );

    if (!mounted) return;

    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  Future<void> _loadTrainingCycleProgress() async {
  final manager = WorkoutScope.of(context);

  final progress = await manager.getTrainingCycleProgress();

  if (!mounted) return;

  setState(() {
    _cycleProgress = progress;
  });
}

  Future<void> _loadSuggestedExercises() async {
  final exercises = await loadAllExercises();

  final suggestions = <Exercise>[];
  final usedGroups = <String>{};

  for (final exercise in exercises) {
    if (usedGroups.add(exercise.muscleGroup)) {
      suggestions.add(exercise);
    }

    if (suggestions.length == 3) break;
  }

  if (!mounted) return;

  setState(() {
    _suggestedExercises = suggestions;
    _isLoadingExercises = false;
  });
}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final programManager = TrainingProgramScope.of(context);

final programs = programManager.programs;

final isArabic =
    Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'FitForge',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 23,
                    backgroundColor: purpleColor,
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Welcome
              Text(
                l10n.homeWelcome,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeTagline,
                style: const TextStyle(fontSize: 15, color: Colors.white60),
              ),

              const SizedBox(height: 25),

             // Training cycle
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(22),
    gradient: const LinearGradient(
      colors: [purpleColor, Color(0xFF4932C9)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(
            Icons.track_changes,
            color: Colors.white,
            size: 35,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'دورتك التدريبية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            _cycleProgress == null
                ? '--'
                : '${_cycleProgress!.completedDays}/${_cycleProgress!.targetDays}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        _cycleProgress == null
            ? 'جارٍ تحميل تقدمك...'
            : _cycleProgress!.isCompleted
                ? 'أكملت الدورة التدريبية بنجاح!'
                : 'متبقي ${_cycleProgress!.remainingDays} يوم تدريب لإكمال الدورة',
        style: const TextStyle(color: Colors.white70),
      ),
      const SizedBox(height: 16),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: _cycleProgress?.progress ?? 0,
          minHeight: 9,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      ),
    ],
  ),
),

              const SizedBox(height: 25),

              // Statistics
              // Start Workout Button
SizedBox(
  width: double.infinity,
  height: 58,
  child: ElevatedButton.icon(
    onPressed: () {
      context.push(AppRouter.workoutSetup);
    },
    icon: const Icon(
      Icons.fitness_center,
      color: Colors.white,
    ),
    label: Text(
      l10n.startWorkout,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: purpleColor,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
),

const SizedBox(height: 30),
              // Monthly Activity
Text(
  l10n.todayActivity,
  style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),
const SizedBox(height: 15),

if (_isLoading)
  const Center(
    child: CircularProgressIndicator(
      color: purpleColor,
    ),
  )
else ...[
  Row(
    children: [
      Expanded(
        child: _StatCard(
          icon: Icons.fitness_center,
          iconColor: purpleColor,
          title: l10n.todayActivity,
          value: '${_stats?.workoutCount ?? 0}',
          subtitle: l10n.todayActivity,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _StatCard(
          icon: Icons.calendar_month,
          iconColor: pinkColor,
          title: l10n.todayActivity,
          value: '${_stats?.trainingDays ?? 0}',
          subtitle: l10n.todayActivity,
        ),
      ),
    ],
  ),
  const SizedBox(height: 12),
  Row(
    children: [
      Expanded(
        child: _StatCard(
          icon: Icons.timer_outlined,
          iconColor: Colors.orangeAccent,
          title: l10n.workoutTime,
          value: (_stats?.totalDuration.inMinutes ?? 0).toString(),
          subtitle: l10n.minutesTarget,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _StatCard(
          icon: Icons.monitor_weight_outlined,
          iconColor: Colors.lightBlueAccent,
          title: l10n.totalWeightLifted,
          value: (_stats?.totalWeightLifted ?? 0).toStringAsFixed(0),
          subtitle: l10n.workoutTime,
        ),
      ),
    ],
  ),
],

              // Programs header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.trainingPrograms,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRouter.programs),
                    child: Text(
                      l10n.viewAll,
                      style: const TextStyle(color: purpleColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
  height: 175,
  child: programManager.isLoading
      ? const Center(
          child: CircularProgressIndicator(
            color: purpleColor,
          ),
        )
      : programs.isEmpty
          ? Center(
              child: Text(
                l10n.trainingPrograms,
                style: const TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: programs.length,
              itemBuilder: (context, index) {
                final program = programs[index];

                return _ProgramCard(
                  title: program.nameFor(isArabic),
                  subtitle:
                      '${program.durationWeeks} ${l10n.weeks4}',
                  icon: Icons.fitness_center,
                );
              },
            ),
),

              const SizedBox(height: 25),

              // Exercises
              Text(
                l10n.suggestedExercises,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              if (_isLoadingExercises)
  const Center(
    child: CircularProgressIndicator(
      color: purpleColor,
    ),
  )
else if (_suggestedExercises.isEmpty)
  const Text(
    'لا توجد تمارين متاحة حالياً',
    style: TextStyle(color: Colors.white54),
  )
else
  ..._suggestedExercises.map(
    (exercise) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _ExerciseTile(
        title: isArabic ? exercise.name : (exercise.nameEn ?? exercise.name),
        subtitle: '${exercise.suggestedSets} × ${exercise.suggestedReps}',
        icon: Icons.fitness_center,
        image: exercise.image,
        onTap: () {
          context.push(
            AppRouter.exerciseDetails,
            extra: exercise,
          );
        },
      ),
    ),
  ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 27),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ProgramCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsetsDirectional.only(end: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: purpleColor.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: purpleColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: pinkColor, size: 28),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String image;
  final VoidCallback onTap;

  const _ExerciseTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.isNotEmpty
                  ? Image.asset(
                      image,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildExerciseIcon();
                      },
                    )
                  : _buildExerciseIcon(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill,
              color: purpleColor,
              size: 35,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseIcon() {
    return Container(
      width: 65,
      height: 65,
      color: purpleColor.withValues(alpha: 0.18),
      child: Icon(
        icon,
        color: pinkColor,
        size: 30,
      ),
    );
  }
}
