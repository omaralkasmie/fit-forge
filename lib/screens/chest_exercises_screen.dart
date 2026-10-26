import 'package:flutter/material.dart';

const Color chestBgColor = Color(0xFF0B0B16);
const Color chestCardColor = Color(0xFF15182F);
const Color chestPurpleColor = Color(0xFF9B5CFF);
const Color chestPinkColor = Color(0xFFE34DFF);

class ChestExercisesScreen extends StatelessWidget {
  const ChestExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: chestBgColor,
        appBar: AppBar(
          backgroundColor: chestBgColor,
          foregroundColor: Colors.white,
          title: const Text(
            'تمارين الصدر',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [chestPurpleColor, Color(0xFF4932C9)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'تمارين بناء عضلات الصدر',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ابدأ بوزن مناسب لك، واهتم بصحة الحركة.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'قائمة التمارين',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const _ChestExerciseTile(
              number: '01',
              title: 'تمرين الضغط',
              subtitle: '3 مجموعات × 10 تكرارات',
              icon: Icons.accessibility_new,
            ),
            const SizedBox(height: 12),
            const _ChestExerciseTile(
              number: '02',
              title: 'ضغط الصدر بالدمبل',
              subtitle: '3 مجموعات × 12 تكرارًا',
              icon: Icons.fitness_center,
            ),
            const SizedBox(height: 12),
            const _ChestExerciseTile(
              number: '03',
              title: 'تفتيح الصدر بالدمبل',
              subtitle: '3 مجموعات × 12 تكرارًا',
              icon: Icons.sports_gymnastics,
            ),
            const SizedBox(height: 12),
            const _ChestExerciseTile(
              number: '04',
              title: 'ضغط الصدر المائل',
              subtitle: '3 مجموعات × 10 تكرارات',
              icon: Icons.fitness_center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChestExerciseTile extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;

  const _ChestExerciseTile({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: chestCardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: chestPurpleColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: chestPurpleColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: chestPinkColor,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
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
          Text(
            number,
            style: const TextStyle(
              color: chestPurpleColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}