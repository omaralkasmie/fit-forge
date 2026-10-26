import 'package:flutter/material.dart';
import 'chest_exercises_screen.dart';

const Color exercisesBgColor = Color(0xFF0B0B16);
const Color exercisesCardColor = Color(0xFF15182F);
const Color exercisesPurpleColor = Color(0xFF9B5CFF);
const Color exercisesPinkColor = Color(0xFFE34DFF);

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: exercisesBgColor,
        appBar: AppBar(
          backgroundColor: exercisesBgColor,
          foregroundColor: Colors.white,
          title: const Text(
            'التمارين',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'اكتشف تمارينك',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اختر مجموعة العضلات التي تريد تدريبها',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
            _ExerciseCategory(
                onTap:() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChestExercisesScreen(),
                        ),
                    );
                },
              title: 'تمارين الصدر',
              subtitle: 'تقوية عضلات الصدر',
              icon: Icons.fitness_center,
              color: exercisesPurpleColor,
            ),
            const SizedBox(height: 14),
            _ExerciseCategory(
              title: 'تمارين الظهر',
              subtitle: 'تقوية عضلات الظهر',
              icon: Icons.accessibility_new,
              color: exercisesPinkColor,
            ),
            const SizedBox(height: 14),
            _ExerciseCategory(
              title: 'تمارين الأكتاف',
              subtitle: 'بناء أكتاف قوية',
              icon: Icons.sports_gymnastics,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 14),
            _ExerciseCategory(
              title: 'تمارين الأرجل',
              subtitle: 'تقوية عضلات الجزء السفلي',
              icon: Icons.directions_run,
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 14),
            _ExerciseCategory(
              title: 'تمارين الذراعين',
              subtitle: 'تدريب العضلة الثنائية والثلاثية',
              icon: Icons.sports_handball,
              color: exercisesPinkColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCategory extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ExerciseCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: exercisesCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back_ios_new,
            color: color,
            size: 18,
          ),
        ],
      ),
    ),
    );
  }
}