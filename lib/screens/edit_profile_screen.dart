import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../services/user_scope.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalController = TextEditingController();

  String? _gender;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    final profile = UserScope.of(context).profile;

    _nameController.text = profile?.name ?? '';
    _emailController.text = profile?.email ?? '';
    _ageController.text = profile?.age?.toString() ?? '';
    _weightController.text = profile?.weight?.toString() ?? '';
    _heightController.text = profile?.height?.toString() ?? '';
    _goalController.text = profile?.fitnessGoal ?? '';
    _gender = profile?.gender;

    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }

  int? _parseInt(String value) {
    if (value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    final userManager = UserScope.of(context);
    final currentProfile = userManager.profile;
    final now = DateTime.now();

    final profile = UserProfile(
      id: currentProfile?.id ?? 'local-user',
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      age: _parseInt(_ageController.text),
      weight: _parseDouble(_weightController.text),
      height: _parseDouble(_heightController.text),
      fitnessGoal: _goalController.text.trim().isEmpty
          ? null
          : _goalController.text.trim(),
      gender: _gender,
      createdAt: currentProfile?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await userManager.saveProfile(profile);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileSaved)),
      );

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileSaveError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF080B1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080B1B),
        title: Text(
          l10n.editProfile,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildField(
              controller: _nameController,
              label: l10n.fullName,
              hint: l10n.nameHint,
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredName;
                }
                return null;
              },
            ),
            _buildField(
              controller: _emailController,
              label: l10n.emailAddress,
              hint: l10n.emailHint,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildField(
              controller: _ageController,
              label: l10n.ageLabel,
              icon: Icons.calendar_month,
              keyboardType: TextInputType.number,
            ),
            _buildField(
              controller: _weightController,
              label: l10n.weightProfile,
              icon: Icons.monitor_weight_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            _buildField(
              controller: _heightController,
              label: l10n.heightProfile,
              icon: Icons.height,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            _buildField(
              controller: _goalController,
              label: l10n.fitnessGoal,
              icon: Icons.flag_outlined,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.genderLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              dropdownColor: const Color(0xFF12172F),
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration(
                icon: Icons.people_outline,
              ),
              items: [
                DropdownMenuItem(
                  value: 'male',
                  child: Text(l10n.male),
                ),
                DropdownMenuItem(
                  value: 'female',
                  child: Text(l10n.female),
                ),
              ],
              onChanged: (value) {
                setState(() => _gender = value);
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.save,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF8B5CF6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        textDirection: TextDirection.ltr,
        style: const TextStyle(color: Colors.white),
        decoration: _fieldDecoration(
          label: label,
          hint: hint,
          icon: icon,
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    String? label,
    String? hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFFB9A1F7)),
      hintStyle: const TextStyle(color: Color(0xFF777D91)),
      prefixIcon: Icon(icon, color: const Color(0xFFB9A1F7)),
      filled: true,
      fillColor: const Color(0xFF12172F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF8B5CF6),
        ),
      ),
    );
  }
}