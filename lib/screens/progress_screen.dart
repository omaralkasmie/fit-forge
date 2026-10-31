import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navigation.dart';


const Color progressBg = Color(0xFF080B1B);
const Color progressCard = Color(0xFF10142B);
const Color progressPurple = Color(0xFF7138FF);
const Color progressPink = Color(0xFFED168E);
const Color progressBlue = Color(0xFF168BFF);
const Color progressGreen = Color(0xFF20D6A1);

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: progressBg,
        appBar: AppBar(
          backgroundColor: progressBg,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'تقدمي الرياضي',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            const Text(
              'ملخص نشاطك',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStats(),
            const SizedBox(height: 26),
            _buildWeightCard(),
            const SizedBox(height: 26),
            _buildAchievements(),
          ],
        ),
        bottomNavigationBar:const CustomBottomNavigation(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF5627DF), Color(0xFF11143A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.insights, color: Colors.white, size: 34),
          SizedBox(height: 14),
          Text(
            'كل تمرين يقربك من هدفك',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'تابع تقدمك واستمر في بناء نسخة أقوى من نفسك.',
            style: TextStyle(
              color: Color(0xFFD3D4F4),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'التمارين',
            value: '24',
            subtitle: 'هذا الشهر',
            icon: Icons.fitness_center,
            color: progressPurple,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'أيام التدريب',
            value: '12',
            subtitle: 'هذا الشهر',
            icon: Icons.calendar_month,
            color: progressPink,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'الساعات',
            value: '18',
            subtitle: 'ساعة تدريب',
            icon: Icons.timer_outlined,
            color: progressBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'تطور الوزن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.show_chart, color: progressPurple, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'آخر 7 أسابيع',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '75.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'كغم',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: progressGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'الوزن الحالي',
                  style: TextStyle(color: progressGreen, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeightBar(height: 52, label: '1'),
                _WeightBar(height: 64, label: '2'),
                _WeightBar(height: 58, label: '3'),
                _WeightBar(height: 78, label: '4'),
                _WeightBar(height: 88, label: '5'),
                _WeightBar(height: 98, label: '6'),
                _WeightBar(height: 112, label: '7'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'الأسبوع',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إنجازاتك',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const _AchievementCard(
          icon: Icons.local_fire_department,
          title: 'بداية قوية',
          description: 'أكملت 10 أيام تدريب',
          color: progressPink,
        ),
        const SizedBox(height: 12),
        const _AchievementCard(
          icon: Icons.bolt,
          title: 'طاقة مستمرة',
          description: 'أنجزت 20 تمرينًا',
          color: progressOrange,
        ),
      ],
    );
  }
}

const Color progressOrange = Color(0xFFFF851B);

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _WeightBar extends StatelessWidget {
  final double height;
  final String label;

  const _WeightBar({required this.height, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [progressPurple, Color(0xFFB04AFF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: color, size: 24),
        ],
      ),
    );
  }
}
