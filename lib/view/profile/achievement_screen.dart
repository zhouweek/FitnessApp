import 'package:fitnessapp/i18n/intl_extension.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementScreen extends StatefulWidget {
  static const String routeName = '/AchievementScreen';

  const AchievementScreen({Key? key}) : super(key: key);

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int selectedCategory = 0;
  bool isLoading = true;

  final List<String> categories = ['all', 'workout', 'nutrition', 'streak'];

  List<Achievement> achievements = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');
    if (phone == null) {
      setState(() {
        achievements = _buildAchievements(0, 0, 0, 0, 0);
        isLoading = false;
      });
      return;
    }

    final db = DatabaseHelper();
    final totalWorkouts = await db.getWorkoutCount(phone);
    final totalDays = await db.getDistinctWorkoutDays(phone);
    final totalCalories = await db.getTotalCalories(phone);
    final consecutiveDays = await db.getConsecutiveWorkoutDays(phone);
    final typeCounts = await db.getWorkoutCountByType(phone);
    final lowerBodyCount = typeCounts['lower_body_workout'] ?? 0;

    setState(() {
      achievements = _buildAchievements(
        totalWorkouts,
        totalDays,
        totalCalories,
        consecutiveDays,
        lowerBodyCount,
      );
      isLoading = false;
    });
  }

  List<Achievement> _buildAchievements(
    int totalWorkouts,
    int totalDays,
    double totalCalories,
    int consecutiveDays,
    int lowerBodyCount,
  ) {
    return [
      Achievement(
        title: 'first_workout',
        desc: 'first_workout_desc',
        icon: Icons.emoji_events,
        isUnlocked: totalWorkouts >= 1,
        category: 'workout',
        color: AppColors.primaryColor1,
        currentProgress: totalWorkouts,
        targetProgress: 1,
      ),
      Achievement(
        title: 'run_10km',
        desc: 'run_10km_desc',
        icon: Icons.directions_run,
        isUnlocked: lowerBodyCount >= 5,
        category: 'workout',
        color: AppColors.secondaryColor1,
        currentProgress: lowerBodyCount,
        targetProgress: 5,
      ),
      Achievement(
        title: 'workout_30_days',
        desc: 'workout_30_days_desc',
        icon: Icons.calendar_month,
        isUnlocked: totalDays >= 30,
        category: 'streak',
        color: AppColors.primaryColor2,
        currentProgress: totalDays,
        targetProgress: 30,
      ),
      Achievement(
        title: 'calorie_master',
        desc: 'calorie_master_desc',
        icon: Icons.local_fire_department,
        isUnlocked: totalCalories >= 5000,
        category: 'nutrition',
        color: AppColors.secondaryColor2,
        currentProgress: totalCalories.toInt(),
        targetProgress: 5000,
      ),
      Achievement(
        title: 'early_bird',
        desc: 'early_bird_desc',
        icon: Icons.wb_sunny,
        isUnlocked: consecutiveDays >= 7,
        category: 'streak',
        color: AppColors.primaryColor1,
        currentProgress: consecutiveDays,
        targetProgress: 7,
      ),
      Achievement(
        title: 'iron_will',
        desc: 'iron_will_desc',
        icon: Icons.fitness_center,
        isUnlocked: totalWorkouts >= 50,
        category: 'workout',
        color: AppColors.secondaryColor1,
        currentProgress: totalWorkouts,
        targetProgress: 50,
      ),
      Achievement(
        title: 'hydration_hero',
        desc: 'hydration_hero_desc',
        icon: Icons.water_drop,
        isUnlocked: totalDays >= 30,
        category: 'nutrition',
        color: AppColors.primaryColor2,
        currentProgress: totalDays,
        targetProgress: 30,
      ),
      Achievement(
        title: 'centurion',
        desc: 'centurion_desc',
        icon: Icons.star,
        isUnlocked: totalWorkouts >= 100,
        category: 'workout',
        color: AppColors.secondaryColor2,
        currentProgress: totalWorkouts,
        targetProgress: 100,
      ),
    ];
  }

  List<Achievement> get filteredAchievements {
    if (selectedCategory == 0) return achievements;
    return achievements
        .where((a) => a.category == categories[selectedCategory])
        .toList();
  }

  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "achievement".intl(context),
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryG),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "my_achievements".intl(context),
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "$unlockedCount/${achievements.length} ${"unlocked".intl(context)}",
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 55,
                              height: 55,
                              child: CircularProgressIndicator(
                                value: achievements.isEmpty ? 0 : unlockedCount / achievements.length,
                                strokeWidth: 5,
                                backgroundColor: AppColors.whiteColor.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.whiteColor),
                              ),
                            ),
                            Text(
                              "${(achievements.isEmpty ? 0 : unlockedCount / achievements.length * 100).toInt()}%",
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 35,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        bool isSelected = selectedCategory == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: AppColors.primaryG)
                                  : null,
                              color: isSelected ? null : AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              categories[index].intl(context),
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.grayColor,
                                fontSize: 12,
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: filteredAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = filteredAchievements[index];
                      final progress = achievement.targetProgress > 0
                          ? (achievement.currentProgress / achievement.targetProgress).clamp(0.0, 1.0)
                          : 0.0;
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: achievement.isUnlocked
                              ? AppColors.whiteColor
                              : AppColors.lightGrayColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: achievement.isUnlocked
                              ? const [BoxShadow(color: Colors.black12, blurRadius: 2)]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: achievement.isUnlocked
                                    ? LinearGradient(
                                        colors: [
                                          achievement.color,
                                          achievement.color.withOpacity(0.6),
                                        ],
                                      )
                                    : null,
                                color: achievement.isUnlocked
                                    ? null
                                    : AppColors.grayColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                achievement.isUnlocked
                                    ? achievement.icon
                                    : Icons.lock_outline,
                                color: achievement.isUnlocked
                                    ? AppColors.whiteColor
                                    : AppColors.grayColor.withOpacity(0.5),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              achievement.title.intl(context),
                              style: TextStyle(
                                color: achievement.isUnlocked
                                    ? AppColors.blackColor
                                    : AppColors.grayColor.withOpacity(0.5),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement.desc.intl(context),
                              style: TextStyle(
                                color: achievement.isUnlocked
                                    ? AppColors.grayColor
                                    : AppColors.grayColor.withOpacity(0.4),
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!achievement.isUnlocked) ...[
                              const SizedBox(height: 6),
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.grayColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: progress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: AppColors.primaryG),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${achievement.currentProgress}/${achievement.targetProgress}',
                                style: TextStyle(
                                  color: AppColors.grayColor.withOpacity(0.6),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class Achievement {
  final String title;
  final String desc;
  final IconData icon;
  final bool isUnlocked;
  final String category;
  final Color color;
  final int currentProgress;
  final int targetProgress;

  Achievement({
    required this.title,
    required this.desc,
    required this.icon,
    required this.isUnlocked,
    required this.category,
    required this.color,
    this.currentProgress = 0,
    this.targetProgress = 1,
  });
}
