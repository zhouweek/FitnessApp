
import 'package:fitnessapp/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:fitnessapp/view/home/bmi_detail_screen.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/notification/notification_screen.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fitnessapp/view/profile/achievement_screen.dart';
import 'package:fitnessapp/view/profile/activity_history_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/profile/contact_us_screen.dart';
import 'package:fitnessapp/view/profile/edit_profile_screen.dart';
import 'package:fitnessapp/view/profile/personal_progress_screen.dart';
import 'package:fitnessapp/view/profile/privacy_policy_screen.dart';
import 'package:fitnessapp/view/profile/workout_progress_screen.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:fitnessapp/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  StartScreen.routeName: (context) => const StartScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  ActivityHistoryScreen.routeName: (context) => const ActivityHistoryScreen(),
  WorkoutProgressScreen.routeName: (context) => const WorkoutProgressScreen(),
  PersonalProgressScreen.routeName: (context) => const PersonalProgressScreen(),
  AchievementScreen.routeName: (context) => const AchievementScreen(),
  ContactUsScreen.routeName: (context) => const ContactUsScreen(),
  PrivacyPolicyScreen.routeName: (context) => const PrivacyPolicyScreen(),
  YourGoalScreen.routeName: (context) => const YourGoalScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  FinishWorkoutScreen.routeName: (context) => const FinishWorkoutScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  ActivityTrackerScreen.routeName: (context) => const ActivityTrackerScreen(),
  BmiDetailScreen.routeName: (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    return BmiDetailScreen(
      bmi: (args['bmi'] as num?)?.toDouble() ?? 0,
      height: (args['height'] as num?)?.toDouble() ?? 170,
      weight: (args['weight'] as num?)?.toDouble() ?? 60,
    );
  },
  WorkoutScheduleView.routeName: (context) => const WorkoutScheduleView(),
};