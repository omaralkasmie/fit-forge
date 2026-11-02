import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes/app_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF10142B),
        border: Border(
          top: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: l10n.navHome,
            selected: currentLocation == AppRouter.home,
            onTap: () => context.go(AppRouter.home),
          ),
          _NavItem(
            icon: Icons.fitness_center,
            label: l10n.navExercises,
            selected: currentLocation == AppRouter.exercises ||
                currentLocation == AppRouter.chestExercises,
            onTap: () => context.go(AppRouter.exercises),
          ),
          _NavItem(
            icon: Icons.calendar_month_rounded,
            label: l10n.navPrograms,
            selected: currentLocation == AppRouter.programs,
            onTap: () => context.go(AppRouter.programs),
          ),
          _NavItem(
            icon: Icons.insights_rounded,
            label: l10n.navProgress,
            selected: currentLocation == AppRouter.progress,
            onTap: () => context.go(AppRouter.progress),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: l10n.navProfile,
            selected: currentLocation == AppRouter.profile,
            onTap: () => context.go(AppRouter.profile),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFFB04AFF)
        : Colors.white54;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 23),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}