import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_router.dart';
import '../widgets/custom_bottom_navigation.dart';

const Color bgColor = Color(0xFF0B0B16);
const Color cardColor = Color(0xFF15182F);
const Color purpleColor = Color(0xFF9B5CFF);
const Color pinkColor = Color(0xFFE34DFF);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Welcome
                const Text(
                  'مرحباً بك! 👋',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'معاً نصنع نسخة أقوى منك',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white60,
                  ),
                ),

                const SizedBox(height: 25),

                // Daily goal
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
                      const Row(
                        children: [
                          Icon(
                            Icons.track_changes,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'هدفك اليومي',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '60%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'أكمل تمرينك اليوم لتحقيق هدفك',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const LinearProgressIndicator(
                          value: 0.6,
                          minHeight: 9,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Statistics
                const Text(
                  'نشاطك اليوم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orangeAccent,
                        title: 'السعرات الحرارية',
                        value: '420',
                        subtitle: 'من 800 سعرة',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.timer_outlined,
                        iconColor: purpleColor,
                        title: 'وقت التمرين',
                        value: '35',
                        subtitle: 'من 60 دقيقة',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.directions_walk,
                        iconColor: pinkColor,
                        title: 'الخطوات',
                        value: '6,850',
                        subtitle: 'خطوة اليوم',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.water_drop_outlined,
                        iconColor: Colors.lightBlueAccent,
                        title: 'الماء',
                        value: '1.5 L',
                        subtitle: 'من 2.5 لتر',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Programs header
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'برامج التدريب',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => 
                      context.push(AppRouter.programs),
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(color: purpleColor),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 175,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _ProgramCard(
                        title: 'بناء العضلات',
                        subtitle: '4 أسابيع',
                        icon: Icons.fitness_center,
                      ),
                      _ProgramCard(
                        title: 'حرق الدهون',
                        subtitle: '3 أسابيع',
                        icon: Icons.local_fire_department,
                      ),
                      _ProgramCard(
                        title: 'اللياقة العامة',
                        subtitle: 'مستوى مبتدئ',
                        icon: Icons.directions_run,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Exercises
                const Text(
                  'تمارين مقترحة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                const _ExerciseTile(
                  title: 'تمرين الضغط',
                  subtitle: '3 مجموعات × 12 تكرار',
                  icon: Icons.accessibility_new,
                ),
                const SizedBox(height: 12),
                const _ExerciseTile(
                  title: 'تمرين القرفصاء',
                  subtitle: '3 مجموعات × 15 تكرار',
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 12),
                const _ExerciseTile(
                  title: 'تمرين البلانك',
                  subtitle: '3 مجموعات × 45 ثانية',
                  icon: Icons.self_improvement,
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),

        // Bottom navigation preview
        bottomNavigationBar: const CustomBottomNavigation(),
      ),
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
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
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
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
      margin: const EdgeInsets.only(left: 12),
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
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
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

  const _ExerciseTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: purpleColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: pinkColor, size: 27),
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
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
    );
  }
}
