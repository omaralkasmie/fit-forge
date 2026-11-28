import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/user_scope.dart';

import '../widgets/custom_bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_router.dart';
import '../services/training_program_scope.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final userManager = UserScope.of(context);
    final profile = userManager.profile;
    final trainingProgramManager = TrainingProgramScope.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF080B1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080B1B),
        title: Text(
          l10n.profileTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF12172F),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 45,
                  child: Icon(Icons.person, color: Colors.white, size: 45),
                ),
                const SizedBox(height: 12),
                Text(
                  profile?.name ?? l10n.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.fitforgeMember,
                  style: const TextStyle(
                    color: Color(0xFFB9A1F7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProfileStat(
                      value: profile?.weight?.toString() ?? '_',
                      label: l10n.weightProfile,
                    ),
                    _ProfileStat(
                      value: profile?.height?.toString() ?? '_',
                      label: l10n.heightProfile,
                    ),
                    _ProfileStat(
                      value: trainingProgramManager.programs.length.toString(),
                      label: l10n.programsCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SectionTitle(title: l10n.personalInformation),
          _InfoCard(
            icon: Icons.email_outlined,
            title: l10n.emailAddress,
            value: profile?.email ?? '_',
            isArabic: isArabic,
          ),
          _InfoCard(
            icon: Icons.calendar_month,
            title: l10n.ageLabel,
            value: profile?.age?.toString() ?? '_',
            isArabic: isArabic,
          ),
          _InfoCard(
            icon: Icons.flag_outlined,
            title: l10n.fitnessGoal,
            value: profile?.fitnessGoal ?? '_',
            isArabic: isArabic,
          ),
          const SizedBox(height: 28),
          _SectionTitle(title: l10n.accountSettings),
          _SettingsCard(
            icon: Icons.edit_outlined,
            title: l10n.editProfile,
            subtitle: l10n.updatePersonalInfo,
            onTap: () => context.push(AppRouter.editProfile),
          ),
          _SettingsCard(
            icon: Icons.lock_outline,
            title: l10n.changePassword,
            subtitle: l10n.manageAccountSecurity,
            onTap: () => _showMessage(context, l10n.changePasswordComingSoon),
          ),
          _SettingsCard(
            icon: Icons.logout,
            title: l10n.logout,
            subtitle: l10n.logoutDescription,
            iconColor: const Color(0xFFEF5350),
            onTap: () => _showMessage(context, l10n.logoutComingSoon),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isArabic;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10142B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFFB9A1F7),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor = const Color(0xFFB9A1F7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10142B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}