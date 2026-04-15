import 'package:fitnessapp/common_widgets/round_gradient_button.dart';
import 'package:fitnessapp/i18n/intl_extension.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FinishWorkoutScreen extends StatefulWidget {
  static String routeName = "/FinishWorkoutScreen";
  const FinishWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<FinishWorkoutScreen> createState() => _FinishWorkoutScreenState();
}

class _FinishWorkoutScreenState extends State<FinishWorkoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  "assets/images/complete_workout.png",
                  height: media.width * 0.55,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        "congratulations_finished_workout".intl(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: AppColors.primaryG),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatItem(
                              Icons.local_fire_department,
                              "320",
                              "kcal".intl(context),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppColors.whiteColor.withOpacity(0.3),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            _buildStatItem(
                              Icons.timer_outlined,
                              "30",
                              "minutes".intl(context),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppColors.whiteColor.withOpacity(0.3),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            _buildStatItem(
                              Icons.fitness_center,
                              "1",
                              "workout".intl(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "exercise_is_king".intl(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "-Jack Lalanne",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: RoundGradientButton(
                  title: "back_to_home".intl(context),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.whiteColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.whiteColor.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
