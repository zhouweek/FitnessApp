import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class WorkoutProgressScreen extends StatefulWidget {
  static const String routeName = '/WorkoutProgressScreen';
  const WorkoutProgressScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutProgressScreen> createState() => _WorkoutProgressScreenState();
}

class _WorkoutProgressScreenState extends State<WorkoutProgressScreen> {
  // 模拟健身计划数据
  final List<WorkoutPlan> workoutPlans = [
    WorkoutPlan(
      name: 'Weekly Running Challenge',
      goal: 'Run 30km in a week',
      progress: 0.7,
      current: 21,
      total: 30,
      unit: 'km',
      image: 'assets/images/Workout1.png',
    ),
    WorkoutPlan(
      name: 'Upper Body Strength',
      goal: 'Complete 50 push-ups',
      progress: 0.6,
      current: 30,
      total: 50,
      unit: 'reps',
      image: 'assets/images/pp_2.png',
    ),
    WorkoutPlan(
      name: 'Yoga Practice',
      goal: 'Practice 5 times a week',
      progress: 0.4,
      current: 2,
      total: 5,
      unit: 'sessions',
      image: 'assets/images/pp_1.png',
    ),
    WorkoutPlan(
      name: 'Cycling Challenge',
      goal: 'Cycle 50km in a week',
      progress: 0.3,
      current: 15,
      total: 50,
      unit: 'km',
      image: 'assets/images/Workout2.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Workout Progress",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        itemCount: workoutPlans.length,
        itemBuilder: (context, index) {
          final plan = workoutPlans[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 计划图标
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        plan.image,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // 计划信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            plan.goal,
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // 进度条
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: plan.progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.secondaryG,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 进度信息
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${plan.current} ${plan.unit} / ${plan.total} ${plan.unit}',
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(plan.progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppColors.secondaryColor1,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 健身计划数据模型
class WorkoutPlan {
  final String name;
  final String goal;
  final double progress;
  final int current;
  final int total;
  final String unit;
  final String image;

  WorkoutPlan({
    required this.name,
    required this.goal,
    required this.progress,
    required this.current,
    required this.total,
    required this.unit,
    required this.image,
  });
}