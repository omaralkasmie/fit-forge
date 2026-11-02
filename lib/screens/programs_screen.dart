import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_bottom_navigation.dart';

const Color programsBg = Color(0xFF080B1B);
const Color programsCard = Color(0xFF10142B);
const Color programsPurple = Color(0xFF7138FF);
const Color programsPink = Color(0xFFED168E);
const Color programsBlue = Color(0xFF168BFF);
const Color programsOrange = Color(0xFFFF851B);

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final programs = [
      _Program(
        title: l10n.muscleBuilding,
        description: l10n.muscleBuildingDescription,
        duration: l10n.weeks4,
        level: l10n.intermediateLevel,
        icon: Icons.fitness_center,
        color: programsPurple,
        category: 1,
        image: 'assets/images/muscle_building.jpg',
      ),
      _Program(
        title: l10n.fatBurning,
        description: l10n.fatBurningDescription,
        duration: l10n.weeks3,
        level: l10n.beginnerLevel,
        icon: Icons.local_fire_department,
        color: programsPink,
        category: 2,
        image: 'assets/images/fat_burning.jpg',
      ),
      _Program(
        title: l10n.generalFitness,
        description: l10n.generalFitnessDescription,
        duration: l10n.weeks4,
        level: l10n.beginnerLevel,
        icon: Icons.directions_run,
        color: programsBlue,
        category: 3,
        image: 'assets/images/general_fitness.jpg',
      ),
      _Program(
        title: l10n.advancedProgram,
        description: l10n.advancedProgramDescription,
        duration: l10n.weeks8,
        level: l10n.advancedLevel,
        icon: Icons.star,
        color: programsOrange,
        category: 1,
        image: 'assets/images/advanced_program.png',
      ),
    ];

    final visiblePrograms = selectedFilter == 0
        ? programs
        : programs
            .where((program) => program.category == selectedFilter)
            .toList();

    return Scaffold(
      backgroundColor: programsBg,
      appBar: AppBar(
        backgroundColor: programsBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          l10n.trainingPrograms,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          _buildHero(l10n),
          const SizedBox(height: 24),
          Text(
            l10n.allPrograms,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilters(l10n),
          const SizedBox(height: 22),
          ...visiblePrograms.map(
            (program) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ProgramCard(
                program: program,
                isArabic: isArabic,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  Widget _buildHero(AppLocalizations l10n) {
    return Container(
      height: 175,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF5627DF), Color(0xFF11143A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: Transform.scale(
                scale: 1.15,
                child: Image.asset(
                  'assets/images/hero_athlete.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xF2080B1B),
                    Color(0xCC080B1B),
                    Color(0x33080B1B),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.38, 0.62, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chooseIdealProgram,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.programsHeroSubtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    final filters = [
      (l10n.allFilter, 0),
      (l10n.muscleBuilding, 1),
      (l10n.fatBurning, 2),
      (l10n.generalFitness, 3),
    ];

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = selectedFilter == filter.$2;

          return ChoiceChip(
            label: Text(filter.$1),
            selected: selected,
            onSelected: (_) {
              setState(() => selectedFilter = filter.$2);
            },
            showCheckmark: false,
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
            ),
            selectedColor: programsPurple,
            backgroundColor: programsCard,
            side: BorderSide(
              color: selected
                  ? programsPurple
                  : const Color(0xFF303657),
            ),
          );
        },
      ),
    );
  }
}

class _Program {
  final String title;
  final String description;
  final String duration;
  final String level;
  final IconData icon;
  final Color color;
  final int category;
  final String image;

  const _Program({
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.icon,
    required this.color,
    required this.category,
    required this.image,
  });
}

class _ProgramCard extends StatelessWidget {
  final _Program program;
  final bool isArabic;

  const _ProgramCard({
    required this.program,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 202,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: programsCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: program.color.withValues(alpha: 0.8),
        ),
        gradient: LinearGradient(
          colors: [
            program.color.withValues(alpha: 0.12),
            programsCard,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Opacity(
              opacity: 0.75,
              child: Image.asset(
                program.image,
                width: 166,
                height: 175,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.7),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 70,
                    color: program.color.withValues(alpha: 0.22),
                    child: Icon(
                      program.icon,
                      size: 38,
                      color: program.color,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Directionality(
              textDirection:
                  isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      program.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFBFC5E8),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: program.color,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        program.duration,
                        style: const TextStyle(
                          color: Color(0xFFBFC5E8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.signal_cellular_alt,
                        color: program.color,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          program.level,
                          style: const TextStyle(
                            color: Color(0xFFBFC5E8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}