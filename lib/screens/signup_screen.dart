import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.fitness_center,
                  size: 64,
                  color: Color(0xFFB47AFF),
                ),
                const SizedBox(height: 16),
                const Text(
                  'انضم إلى FitForge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ابدأ اليوم ببناء نسخة أقوى من نفسك',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 32),

                const Text('الاسم الكامل', textAlign: TextAlign.right),
                const SizedBox(height: 8),
                const TextField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'أدخل اسمك الكامل',
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Color(0xFF171722),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'البريد الإلكتروني',
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                const TextField(
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Color(0xFF171722),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                const Text('كلمة المرور', textAlign: TextAlign.right),
                const SizedBox(height: 8),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'أنشئ كلمة مرور',
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Color(0xFF171722),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'تأكيد كلمة المرور',
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'أعد إدخال كلمة المرور',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                    filled: true,
                    fillColor: Color(0xFF171722),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF9B5CFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'لديك حساب بالفعل؟ ',
                      style: TextStyle(color: Colors.white60),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRouter.login),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Color(0xFFB47AFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}