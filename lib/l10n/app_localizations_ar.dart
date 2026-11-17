// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'FitForge';

  @override
  String get welcome => 'مرحباً بك في FitForge';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get home => 'الرئيسية';

  @override
  String get exercises => 'التمارين';

  @override
  String get programs => 'البرامج';

  @override
  String get progress => 'التقدم';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get tagline => 'اصنع قوتك، وحقق هدفك';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لمتابعة رحلتك الرياضية';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signupTitle => 'انضم إلى FitForge';

  @override
  String get signupSubtitle => 'ابدأ اليوم ببناء نسخة أقوى من نفسك';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNameHint => 'أدخل اسمك الكامل';

  @override
  String get passwordCreateHint => 'أنشئ كلمة مرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get homeWelcome => 'مرحباً بك! 👋';

  @override
  String get homeTagline => 'معاً نصنع نسخة أقوى منك';

  @override
  String get dailyGoal => 'هدفك اليومي';

  @override
  String get dailyGoalSubtitle => 'أكمل تمرينك اليوم لتحقيق هدفك';

  @override
  String get todayActivity => 'نشاطك اليوم';

  @override
  String get calories => 'السعرات الحرارية';

  @override
  String get caloriesTarget => 'من 800 سعرة';

  @override
  String get workoutTime => 'وقت التمرين';

  @override
  String get minutesTarget => 'من 60 دقيقة';

  @override
  String get steps => 'الخطوات';

  @override
  String get stepsToday => 'خطوة اليوم';

  @override
  String get water => 'الماء';

  @override
  String get waterTarget => 'من 2.5 لتر';

  @override
  String get trainingPrograms => 'برامج التدريب';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get muscleBuilding => 'بناء العضلات';

  @override
  String get weeks4 => '4 أسابيع';

  @override
  String get fatBurning => 'حرق الدهون';

  @override
  String get weeks3 => '3 أسابيع';

  @override
  String get generalFitness => 'اللياقة العامة';

  @override
  String get beginnerLevel => 'مستوى مبتدئ';

  @override
  String get suggestedExercises => 'تمارين مقترحة';

  @override
  String get pushUps => 'تمرين الضغط';

  @override
  String get squats => 'تمرين القرفصاء';

  @override
  String get plank => 'تمرين البلانك';

  @override
  String setsReps(Object count) {
    return '3 مجموعات × $count تكرار';
  }

  @override
  String setsSeconds(Object count) {
    return '3 مجموعات × $count ثانية';
  }

  @override
  String get exercisesTitle => 'التمارين';

  @override
  String get discoverExercises => 'اكتشف تمارينك';

  @override
  String get chooseMuscleGroup => 'اختر مجموعة العضلات التي تريد تدريبها';

  @override
  String get chestExercises => 'تمارين الصدر';

  @override
  String get chestDescription => 'تقوية عضلات الصدر';

  @override
  String get backExercises => 'تمارين الظهر';

  @override
  String get backDescription => 'تقوية عضلات الظهر';

  @override
  String get shoulderExercises => 'تمارين الأكتاف';

  @override
  String get shoulderDescription => 'بناء أكتاف قوية';

  @override
  String get legExercises => 'تمارين الأرجل';

  @override
  String get legDescription => 'تقوية عضلات الجزء السفلي';

  @override
  String get armExercises => 'تمارين الذراعين';

  @override
  String get armDescription => 'تدريب العضلة الثنائية والثلاثية';

  @override
  String get chestScreenTitle => 'تمارين الصدر';

  @override
  String get chestBannerTitle => 'تمارين بناء عضلات الصدر';

  @override
  String get chestBannerSubtitle => 'ابدأ بوزن مناسب لك، واهتم بصحة الحركة.';

  @override
  String get exerciseListTitle => 'قائمة التمارين';

  @override
  String setsLabel(Object count) {
    return '$count مجموعات';
  }

  @override
  String repsLabel(Object count) {
    return '$count تكرارات';
  }

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم';

  @override
  String get chestMuscleGroup => 'عضلات الصدر';

  @override
  String get upperChestMuscleGroup => 'عضلات الصدر العلوية';

  @override
  String get barbellEquipment => 'بار حديدي';

  @override
  String get dumbbellEquipment => 'دمبل';

  @override
  String get bodyweightEquipment => 'وزن الجسم';

  @override
  String get exerciseDetailsTitle => 'تفاصيل التمرين';

  @override
  String get exerciseDescriptionTitle => 'وصف التمرين';

  @override
  String get targetMusclesTitle => 'العضلات المستهدفة';

  @override
  String get exerciseInformationTitle => 'معلومات التمرين';

  @override
  String get equipmentLabel => 'المعدات';

  @override
  String get difficultyLabel => 'مستوى الصعوبة';

  @override
  String get setsCountLabel => 'عدد المجموعات';

  @override
  String get repsCountLabel => 'عدد التكرارات';

  @override
  String get exerciseInstructionsTitle => 'طريقة أداء التمرين';

  @override
  String get commonMistakesTitle => 'أخطاء شائعة';

  @override
  String get allPrograms => 'جميع البرامج';

  @override
  String get chooseIdealProgram => 'اختر برنامجك المثالي';

  @override
  String get programsHeroSubtitle => 'برامج تدريبية مصممة خصيصًا لمساعدتك\nعلى تحقيق أهدافك الرياضية';

  @override
  String get advancedProgram => 'برنامج متقدم';

  @override
  String get advancedProgramDescription => 'تحدٍّ أقوى للمتمرنين لتحقيق أفضل النتائج.';

  @override
  String get muscleBuildingDescription => 'برنامج متكامل لزيادة الكتلة العضلية وتحسين القوة البدنية.';

  @override
  String get fatBurningDescription => 'برنامج فعال لحرق السعرات الحرارية وتقليل نسبة الدهون.';

  @override
  String get generalFitnessDescription => 'تحسين اللياقة البدنية والصحة العامة وزيادة النشاط اليومي.';

  @override
  String get weeks8 => '8 أسابيع';

  @override
  String get intermediateLevel => 'متوسط';

  @override
  String get advancedLevel => 'متقدم';

  @override
  String get allFilter => 'الكل';

  @override
  String get progressTitle => 'تقدمي الرياضي';

  @override
  String get activitySummary => 'ملخص نشاطك';

  @override
  String get everyWorkout => 'كل تمرين يقربك من هدفك';

  @override
  String get progressSubtitle => 'تابع تقدمك واستمر في بناء نسخة أقوى من نفسك.';

  @override
  String get workoutsLabel => 'التمارين';

  @override
  String get trainingDaysLabel => 'أيام التدريب';

  @override
  String get hoursLabel => 'الساعات';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get trainingHours => 'ساعة تدريب';

  @override
  String get weightProgress => 'تطور الوزن';

  @override
  String get last7Weeks => 'آخر 7 أسابيع';

  @override
  String get currentWeight => 'الوزن الحالي';

  @override
  String get weightUnit => 'كغم';

  @override
  String get weekLabel => 'الأسبوع';

  @override
  String get achievementsTitle => 'إنجازاتي';

  @override
  String get strongStart => 'بداية قوية';

  @override
  String get completedTrainingDays => 'أكملت 10 أيام تدريب';

  @override
  String get consistentEnergy => 'طاقة مستمرة';

  @override
  String get completedWorkouts => 'أنجزت 20 تمرينًا';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get fitforgeMember => 'عضو في FitForge';

  @override
  String get weightProfile => 'الوزن (كغم)';

  @override
  String get heightProfile => 'الطول (سم)';

  @override
  String get programsCount => 'البرامج';

  @override
  String get personalInformation => 'معلوماتي الشخصية';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get ageLabel => 'العمر';

  @override
  String get ageValue => '25 سنة';

  @override
  String get fitnessGoal => 'الهدف الرياضي';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updatePersonalInfo => 'تحديث بياناتك الشخصية';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get manageAccountSecurity => 'إدارة أمان حسابك';

  @override
  String get logoutDescription => 'الخروج من حسابك';

  @override
  String get editProfileComingSoon => 'سيتم إضافة تعديل الملف الشخصي لاحقاً';

  @override
  String get changePasswordComingSoon => 'سيتم إضافة تغيير كلمة المرور لاحقاً';

  @override
  String get logoutComingSoon => 'سيتم إضافة تسجيل الخروج لاحقاً';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navExercises => 'التمارين';

  @override
  String get navPrograms => 'البرامج';

  @override
  String get navProgress => 'التقدم';

  @override
  String get navProfile => 'حسابي';

  @override
  String get absExercises => 'تمارين البطن';

  @override
  String get workoutSetupTitle => 'إعداد التمرين';

  @override
  String get freeWorkout => 'تمرين حر';

  @override
  String get programWorkout => 'تمرين من برنامج';

  @override
  String get selectedExercises => 'التمارين المختارة';

  @override
  String get addExercises => 'إضافة تمارين';

  @override
  String get startWorkout => 'ابدأ التمرين';

  @override
  String get removeExercise => 'حذف التمرين';

  @override
  String get noExercisesSelected => 'لم تختر أي تمارين بعد';

  @override
  String get selectExercises => 'اختر التمارين';

  @override
  String get searchExercises => 'ابحث عن تمرين';

  @override
  String exerciseCount(Object count) {
    return '$count تمارين';
  }

  @override
  String get activeWorkoutTitle => 'التمرين الحالي';

  @override
  String get workoutProgress => 'تقدم التمرين';

  @override
  String get weightLabel => 'الوزن';

  @override
  String get repsInputLabel => 'التكرارات';

  @override
  String get kgUnit => 'كغم';

  @override
  String get completeSet => 'إكمال المجموعة';

  @override
  String get setCompleted => 'مكتملة';

  @override
  String get finishWorkout => 'إنهاء التمرين';

  @override
  String get workoutCompleted => 'أحسنت! أكملت جميع التمارين';

  @override
  String completedExercisesCount(Object completed, Object total) {
    return '$completed من $total تمارين';
  }

  @override
  String get workoutSummaryTitle => 'ملخص التمرين';

  @override
  String get workoutDuration => 'مدة التمرين';

  @override
  String get exercisesCompleted => 'التمارين المكتملة';

  @override
  String get setsCompleted => 'المجموعات المكتملة';

  @override
  String get totalWeightLifted => 'إجمالي الوزن المرفوع';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get minutesUnit => 'دقيقة';

  @override
  String get kilogramsUnit => 'كغم';

  @override
  String get workoutHistoryTitle => 'سجل التمارين';

  @override
  String get totalWorkouts => 'إجمالي التمارين';

  @override
  String get noWorkoutHistory => 'لا توجد تمارين سابقة';

  @override
  String get startFirstWorkout => 'أكمل أول جلسة تدريبية لتظهر هنا.';

  @override
  String get exercisesLabel => 'التمارين';

  @override
  String get durationLabel => 'المدة';

  @override
  String get workoutHistorySetsLabel => 'المجموعات';

  @override
  String get workoutDetailsTitle => 'تفاصيل التمرين';

  @override
  String get workoutDetailsError => 'تعذر تحميل تفاصيل التمرين';

  @override
  String get workoutExercisesTitle => 'التمارين';

  @override
  String get workoutDetailsDate => 'التاريخ';

  @override
  String get workoutDetailsDuration => 'المدة';

  @override
  String get workoutDetailsExercises => 'عدد التمارين';

  @override
  String get workoutDetailsCompletedSets => 'المجموعات المكتملة';

  @override
  String get workoutDetailsTotalWeight => 'إجمالي الوزن';

  @override
  String get workoutDetailsSet => 'المجموعة';

  @override
  String get workoutDetailsWeight => 'الوزن';

  @override
  String get workoutDetailsReps => 'التكرارات';

  @override
  String get progressWeek => 'هذا الأسبوع';

  @override
  String get progressMonth => 'هذا الشهر';

  @override
  String get progressYear => 'هذه السنة';

  @override
  String get progressActivityTitle => 'نشاطك التدريبي';

  @override
  String get progressActivitySubtitle => 'ملخص نشاطك خلال الفترة المختارة';

  @override
  String get progressNoActivity => 'لا يوجد نشاط تدريبي خلال هذه الفترة';

  @override
  String get progressTotalWeight => 'إجمالي الوزن المرفوع';

  @override
  String get progressPeriodWorkouts => 'جلسات التدريب';

  @override
  String get progressPeriodDays => 'أيام التدريب';

  @override
  String get progressPeriodHours => 'ساعات التدريب';

  @override
  String get weeks => 'أسابيع';

  @override
  String get progressUnlocked => 'تم تحقيق الإنجاز';

  @override
  String get progressLocked => 'واصل التدريب لتحقيق هذا الإنجاز';

  @override
  String get achievementFirstWorkout => 'البداية القوية';

  @override
  String get achievementFirstWorkoutDesc => 'أكمل أول جلسة تدريبية';

  @override
  String get achievementFiveWorkouts => 'ملتزم بالتدريب';

  @override
  String get achievementFiveWorkoutsDesc => 'أكمل 5 جلسات تدريبية';

  @override
  String get achievementTenWorkouts => 'محارب الحديد';

  @override
  String get achievementTenWorkoutsDesc => 'أكمل 10 جلسات تدريبية';

  @override
  String get achievementTenDays => 'رياضي نشيط';

  @override
  String get achievementTenDaysDesc => 'تدرب في 10 أيام مختلفة';

  @override
  String get achievementTwentyFiveWorkouts => 'بطل FitForge';

  @override
  String get achievementTwentyFiveWorkoutsDesc => 'أكمل 25 جلسة تدريبية';

  @override
  String get achievementFiftyWorkouts => 'أسطورة التدريب';

  @override
  String get achievementFiftyWorkoutsDesc => 'أكمل 50 جلسة تدريبية';

  @override
  String get achievementProgress => 'التقدم';

  @override
  String get achievementUnlocked => 'تم فتح الإنجاز';

  @override
  String exerciseCountLabel(int count) {
    return 'عدد التمارين: $count';
  }

  @override
  String get clearFilters => 'إلغاء التصفية';

  @override
  String get equipmentBands => 'أشرطة مقاومة';

  @override
  String get equipmentBarbell => 'بار';

  @override
  String get equipmentBodyOnly => 'وزن الجسم';

  @override
  String get equipmentCable => 'كيبل';

  @override
  String get equipmentDumbbell => 'دامبل';

  @override
  String get equipmentEzCurlBar => 'بار EZ';

  @override
  String get equipmentExerciseBall => 'كرة تمرين';

  @override
  String get equipmentFoamRoll => 'رول';

  @override
  String get equipmentKettlebells => 'كتل بيل';

  @override
  String get equipmentMachine => 'أجهزة';

  @override
  String get equipmentMedicineBall => 'كرة طبية';

  @override
  String get equipmentOther => 'أخرى';

  @override
  String get difficultyBeginner => 'مبتدئ';

  @override
  String get difficultyIntermediate => 'متوسط';

  @override
  String get difficultyAdvanced => 'متقدم';

  @override
  String get freeWorkoutLabel => 'تمرين حر';

  @override
  String get programWorkoutLabel => 'تمرين برنامج';
}
