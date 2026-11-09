import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FitForge'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FitForge'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @programs.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get programs;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Build your strength, achieve your goals'**
  String get tagline;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your fitness journey'**
  String get loginSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Join FitForge'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start building a stronger version of yourself today'**
  String get signupSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @passwordCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get passwordCreateHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome! 👋'**
  String get homeWelcome;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Together, we build a stronger you'**
  String get homeTagline;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @dailyGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your workout to reach your goal'**
  String get dailyGoalSubtitle;

  /// No description provided for @todayActivity.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get todayActivity;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @caloriesTarget.
  ///
  /// In en, this message translates to:
  /// **'of 800 kcal'**
  String get caloriesTarget;

  /// No description provided for @workoutTime.
  ///
  /// In en, this message translates to:
  /// **'Workout Time'**
  String get workoutTime;

  /// No description provided for @minutesTarget.
  ///
  /// In en, this message translates to:
  /// **'of 60 minutes'**
  String get minutesTarget;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @stepsToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s steps'**
  String get stepsToday;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @waterTarget.
  ///
  /// In en, this message translates to:
  /// **'of 2.5 liters'**
  String get waterTarget;

  /// No description provided for @trainingPrograms.
  ///
  /// In en, this message translates to:
  /// **'Training Programs'**
  String get trainingPrograms;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @muscleBuilding.
  ///
  /// In en, this message translates to:
  /// **'Muscle Building'**
  String get muscleBuilding;

  /// No description provided for @weeks4.
  ///
  /// In en, this message translates to:
  /// **'4 weeks'**
  String get weeks4;

  /// No description provided for @fatBurning.
  ///
  /// In en, this message translates to:
  /// **'Fat Burning'**
  String get fatBurning;

  /// No description provided for @weeks3.
  ///
  /// In en, this message translates to:
  /// **'3 weeks'**
  String get weeks3;

  /// No description provided for @generalFitness.
  ///
  /// In en, this message translates to:
  /// **'General Fitness'**
  String get generalFitness;

  /// No description provided for @beginnerLevel.
  ///
  /// In en, this message translates to:
  /// **'Beginner level'**
  String get beginnerLevel;

  /// No description provided for @suggestedExercises.
  ///
  /// In en, this message translates to:
  /// **'Suggested Exercises'**
  String get suggestedExercises;

  /// No description provided for @pushUps.
  ///
  /// In en, this message translates to:
  /// **'Push-ups'**
  String get pushUps;

  /// No description provided for @squats.
  ///
  /// In en, this message translates to:
  /// **'Squats'**
  String get squats;

  /// No description provided for @plank.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get plank;

  /// No description provided for @setsReps.
  ///
  /// In en, this message translates to:
  /// **'3 sets × {count} reps'**
  String setsReps(Object count);

  /// No description provided for @setsSeconds.
  ///
  /// In en, this message translates to:
  /// **'3 sets × {count} seconds'**
  String setsSeconds(Object count);

  /// No description provided for @exercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesTitle;

  /// No description provided for @discoverExercises.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Exercises'**
  String get discoverExercises;

  /// No description provided for @chooseMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Choose the muscle group you want to train'**
  String get chooseMuscleGroup;

  /// No description provided for @chestExercises.
  ///
  /// In en, this message translates to:
  /// **'Chest Exercises'**
  String get chestExercises;

  /// No description provided for @chestDescription.
  ///
  /// In en, this message translates to:
  /// **'Strengthen your chest muscles'**
  String get chestDescription;

  /// No description provided for @backExercises.
  ///
  /// In en, this message translates to:
  /// **'Back Exercises'**
  String get backExercises;

  /// No description provided for @backDescription.
  ///
  /// In en, this message translates to:
  /// **'Strengthen your back muscles'**
  String get backDescription;

  /// No description provided for @shoulderExercises.
  ///
  /// In en, this message translates to:
  /// **'Shoulder Exercises'**
  String get shoulderExercises;

  /// No description provided for @shoulderDescription.
  ///
  /// In en, this message translates to:
  /// **'Build strong shoulders'**
  String get shoulderDescription;

  /// No description provided for @legExercises.
  ///
  /// In en, this message translates to:
  /// **'Leg Exercises'**
  String get legExercises;

  /// No description provided for @legDescription.
  ///
  /// In en, this message translates to:
  /// **'Strengthen your lower body'**
  String get legDescription;

  /// No description provided for @armExercises.
  ///
  /// In en, this message translates to:
  /// **'Arm Exercises'**
  String get armExercises;

  /// No description provided for @armDescription.
  ///
  /// In en, this message translates to:
  /// **'Train your biceps and triceps'**
  String get armDescription;

  /// No description provided for @chestScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Chest Exercises'**
  String get chestScreenTitle;

  /// No description provided for @chestBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Your Chest Muscles'**
  String get chestBannerTitle;

  /// No description provided for @chestBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a suitable weight and focus on proper form.'**
  String get chestBannerSubtitle;

  /// No description provided for @exerciseListTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise List'**
  String get exerciseListTitle;

  /// No description provided for @setsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String setsLabel(Object count);

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String repsLabel(Object count);

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @chestMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get chestMuscleGroup;

  /// No description provided for @upperChestMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Upper Chest'**
  String get upperChestMuscleGroup;

  /// No description provided for @barbellEquipment.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get barbellEquipment;

  /// No description provided for @dumbbellEquipment.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get dumbbellEquipment;

  /// No description provided for @bodyweightEquipment.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get bodyweightEquipment;

  /// No description provided for @exerciseDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Details'**
  String get exerciseDetailsTitle;

  /// No description provided for @exerciseDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Description'**
  String get exerciseDescriptionTitle;

  /// No description provided for @targetMusclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Muscles'**
  String get targetMusclesTitle;

  /// No description provided for @exerciseInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Information'**
  String get exerciseInformationTitle;

  /// No description provided for @equipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipmentLabel;

  /// No description provided for @difficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level'**
  String get difficultyLabel;

  /// No description provided for @setsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of Sets'**
  String get setsCountLabel;

  /// No description provided for @repsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of Repetitions'**
  String get repsCountLabel;

  /// No description provided for @exerciseInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Perform'**
  String get exerciseInstructionsTitle;

  /// No description provided for @commonMistakesTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get commonMistakesTitle;

  /// No description provided for @allPrograms.
  ///
  /// In en, this message translates to:
  /// **'All Programs'**
  String get allPrograms;

  /// No description provided for @chooseIdealProgram.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Ideal Program'**
  String get chooseIdealProgram;

  /// No description provided for @programsHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Training programs designed to help you\nachieve your fitness goals'**
  String get programsHeroSubtitle;

  /// No description provided for @advancedProgram.
  ///
  /// In en, this message translates to:
  /// **'Advanced Program'**
  String get advancedProgram;

  /// No description provided for @advancedProgramDescription.
  ///
  /// In en, this message translates to:
  /// **'A tougher challenge for experienced athletes to achieve better results.'**
  String get advancedProgramDescription;

  /// No description provided for @muscleBuildingDescription.
  ///
  /// In en, this message translates to:
  /// **'A complete program to increase muscle mass and improve strength.'**
  String get muscleBuildingDescription;

  /// No description provided for @fatBurningDescription.
  ///
  /// In en, this message translates to:
  /// **'An effective program to burn calories and reduce body fat.'**
  String get fatBurningDescription;

  /// No description provided for @generalFitnessDescription.
  ///
  /// In en, this message translates to:
  /// **'Improve fitness, overall health, and daily activity.'**
  String get generalFitnessDescription;

  /// No description provided for @weeks8.
  ///
  /// In en, this message translates to:
  /// **'8 weeks'**
  String get weeks8;

  /// No description provided for @intermediateLevel.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediateLevel;

  /// No description provided for @advancedLevel.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedLevel;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progressTitle;

  /// No description provided for @activitySummary.
  ///
  /// In en, this message translates to:
  /// **'Activity Summary'**
  String get activitySummary;

  /// No description provided for @everyWorkout.
  ///
  /// In en, this message translates to:
  /// **'Every workout brings you closer to your goal'**
  String get everyWorkout;

  /// No description provided for @progressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and keep building a stronger you.'**
  String get progressSubtitle;

  /// No description provided for @workoutsLabel.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workoutsLabel;

  /// No description provided for @trainingDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Days'**
  String get trainingDaysLabel;

  /// No description provided for @hoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hoursLabel;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @trainingHours.
  ///
  /// In en, this message translates to:
  /// **'Training Hours'**
  String get trainingHours;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgress;

  /// No description provided for @last7Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Weeks'**
  String get last7Weeks;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnit;

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekLabel;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Achievements'**
  String get achievementsTitle;

  /// No description provided for @strongStart.
  ///
  /// In en, this message translates to:
  /// **'Strong Start'**
  String get strongStart;

  /// No description provided for @completedTrainingDays.
  ///
  /// In en, this message translates to:
  /// **'Completed 10 training days'**
  String get completedTrainingDays;

  /// No description provided for @consistentEnergy.
  ///
  /// In en, this message translates to:
  /// **'Consistent Energy'**
  String get consistentEnergy;

  /// No description provided for @completedWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Completed 20 workouts'**
  String get completedWorkouts;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @fitforgeMember.
  ///
  /// In en, this message translates to:
  /// **'FitForge Member'**
  String get fitforgeMember;

  /// No description provided for @weightProfile.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightProfile;

  /// No description provided for @heightProfile.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightProfile;

  /// No description provided for @programsCount.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get programsCount;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @ageValue.
  ///
  /// In en, this message translates to:
  /// **'25 years'**
  String get ageValue;

  /// No description provided for @fitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goal'**
  String get fitnessGoal;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @manageAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Manage your account security'**
  String get manageAccountSecurity;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get logoutDescription;

  /// No description provided for @editProfileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Profile editing will be available later'**
  String get editProfileComingSoon;

  /// No description provided for @changePasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Password change will be available later'**
  String get changePasswordComingSoon;

  /// No description provided for @logoutComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Log out will be available later'**
  String get logoutComingSoon;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get navExercises;

  /// No description provided for @navPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get navPrograms;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @absExercises.
  ///
  /// In en, this message translates to:
  /// **'Abs Exercises'**
  String get absExercises;

  /// No description provided for @workoutSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Setup'**
  String get workoutSetupTitle;

  /// No description provided for @freeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Free Workout'**
  String get freeWorkout;

  /// No description provided for @programWorkout.
  ///
  /// In en, this message translates to:
  /// **'Program Workout'**
  String get programWorkout;

  /// No description provided for @selectedExercises.
  ///
  /// In en, this message translates to:
  /// **'Selected Exercises'**
  String get selectedExercises;

  /// No description provided for @addExercises.
  ///
  /// In en, this message translates to:
  /// **'Add Exercises'**
  String get addExercises;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @removeExercise.
  ///
  /// In en, this message translates to:
  /// **'Remove Exercise'**
  String get removeExercise;

  /// No description provided for @noExercisesSelected.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t selected any exercises yet'**
  String get noExercisesSelected;

  /// No description provided for @selectExercises.
  ///
  /// In en, this message translates to:
  /// **'Select Exercises'**
  String get selectExercises;

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search Exercises'**
  String get searchExercises;

  /// No description provided for @exerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Exercises'**
  String exerciseCount(Object count);

  /// No description provided for @activeWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Workout'**
  String get activeWorkoutTitle;

  /// No description provided for @workoutProgress.
  ///
  /// In en, this message translates to:
  /// **'Workout Progress'**
  String get workoutProgress;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @repsInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsInputLabel;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @completeSet.
  ///
  /// In en, this message translates to:
  /// **'Complete Set'**
  String get completeSet;

  /// No description provided for @setCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get setCompleted;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish Workout'**
  String get finishWorkout;

  /// No description provided for @workoutCompleted.
  ///
  /// In en, this message translates to:
  /// **'Great! You completed all exercises'**
  String get workoutCompleted;

  /// No description provided for @completedExercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} Exercises'**
  String completedExercisesCount(Object completed, Object total);

  /// No description provided for @workoutSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Summary'**
  String get workoutSummaryTitle;

  /// No description provided for @workoutDuration.
  ///
  /// In en, this message translates to:
  /// **'Workout Duration'**
  String get workoutDuration;

  /// No description provided for @exercisesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exercises Completed'**
  String get exercisesCompleted;

  /// No description provided for @setsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Sets Completed'**
  String get setsCompleted;

  /// No description provided for @totalWeightLifted.
  ///
  /// In en, this message translates to:
  /// **'Total Weight Lifted'**
  String get totalWeightLifted;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesUnit;

  /// No description provided for @kilogramsUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kilogramsUnit;

  /// No description provided for @workoutHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout History'**
  String get workoutHistoryTitle;

  /// No description provided for @totalWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Total Workouts'**
  String get totalWorkouts;

  /// No description provided for @noWorkoutHistory.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkoutHistory;

  /// No description provided for @startFirstWorkout.
  ///
  /// In en, this message translates to:
  /// **'Complete your first workout to see it here.'**
  String get startFirstWorkout;

  /// No description provided for @exercisesLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @workoutHistorySetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get workoutHistorySetsLabel;

  /// No description provided for @workoutDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Details'**
  String get workoutDetailsTitle;

  /// No description provided for @workoutDetailsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load workout details'**
  String get workoutDetailsError;

  /// No description provided for @workoutExercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get workoutExercisesTitle;

  /// No description provided for @workoutDetailsDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get workoutDetailsDate;

  /// No description provided for @workoutDetailsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get workoutDetailsDuration;

  /// No description provided for @workoutDetailsExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get workoutDetailsExercises;

  /// No description provided for @workoutDetailsCompletedSets.
  ///
  /// In en, this message translates to:
  /// **'Completed Sets'**
  String get workoutDetailsCompletedSets;

  /// No description provided for @workoutDetailsTotalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get workoutDetailsTotalWeight;

  /// No description provided for @workoutDetailsSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get workoutDetailsSet;

  /// No description provided for @workoutDetailsWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get workoutDetailsWeight;

  /// No description provided for @workoutDetailsReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutDetailsReps;

  /// No description provided for @progressWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get progressWeek;

  /// No description provided for @progressMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get progressMonth;

  /// No description provided for @progressYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get progressYear;

  /// No description provided for @progressActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Training Activity'**
  String get progressActivityTitle;

  /// No description provided for @progressActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your activity during the selected period'**
  String get progressActivitySubtitle;

  /// No description provided for @progressNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No training activity during this period'**
  String get progressNoActivity;

  /// No description provided for @progressTotalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight Lifted'**
  String get progressTotalWeight;

  /// No description provided for @progressPeriodWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workout Sessions'**
  String get progressPeriodWorkouts;

  /// No description provided for @progressPeriodDays.
  ///
  /// In en, this message translates to:
  /// **'Training Days'**
  String get progressPeriodDays;

  /// No description provided for @progressPeriodHours.
  ///
  /// In en, this message translates to:
  /// **'Training Hours'**
  String get progressPeriodHours;

  /// No description provided for @progressUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked'**
  String get progressUnlocked;

  /// No description provided for @progressLocked.
  ///
  /// In en, this message translates to:
  /// **'Keep training to unlock this achievement'**
  String get progressLocked;

  /// No description provided for @achievementFirstWorkout.
  ///
  /// In en, this message translates to:
  /// **'Strong Start'**
  String get achievementFirstWorkout;

  /// No description provided for @achievementFirstWorkoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first workout'**
  String get achievementFirstWorkoutDesc;

  /// No description provided for @achievementFiveWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Consistent Athlete'**
  String get achievementFiveWorkouts;

  /// No description provided for @achievementFiveWorkoutsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 workouts'**
  String get achievementFiveWorkoutsDesc;

  /// No description provided for @achievementTenWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Iron Warrior'**
  String get achievementTenWorkouts;

  /// No description provided for @achievementTenWorkoutsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 workouts'**
  String get achievementTenWorkoutsDesc;

  /// No description provided for @achievementTenDays.
  ///
  /// In en, this message translates to:
  /// **'Active Athlete'**
  String get achievementTenDays;

  /// No description provided for @achievementTenDaysDesc.
  ///
  /// In en, this message translates to:
  /// **'Train on 10 different days'**
  String get achievementTenDaysDesc;

  /// No description provided for @achievementTwentyFiveWorkouts.
  ///
  /// In en, this message translates to:
  /// **'FitForge Champion'**
  String get achievementTwentyFiveWorkouts;

  /// No description provided for @achievementTwentyFiveWorkoutsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 25 workouts'**
  String get achievementTwentyFiveWorkoutsDesc;

  /// No description provided for @achievementFiftyWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Training Legend'**
  String get achievementFiftyWorkouts;

  /// No description provided for @achievementFiftyWorkoutsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 50 workouts'**
  String get achievementFiftyWorkoutsDesc;

  /// No description provided for @achievementProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get achievementProgress;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked'**
  String get achievementUnlocked;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
