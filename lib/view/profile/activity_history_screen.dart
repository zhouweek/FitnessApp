import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ActivityHistoryScreen extends StatefulWidget {
  static const String routeName = '/ActivityHistoryScreen';
  const ActivityHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  // 模拟活动历史数据
  final List<Activity> activities = [
    Activity(
      type: 'Running',
      duration: '30 min',
      distance: '5 km',
      calories: '300 kcal',
      time: 'Today, 8:30 AM',
      image: 'assets/images/Workout1.png',
    ),
    Activity(
      type: 'Cycling',
      duration: '45 min',
      distance: '15 km',
      calories: '450 kcal',
      time: 'Yesterday, 6:00 PM',
      image: 'assets/images/Workout2.png',
    ),
    Activity(
      type: 'Swimming',
      duration: '20 min',
      distance: '1 km',
      calories: '200 kcal',
      time: '2 days ago, 10:00 AM',
      image: 'assets/images/Workout3.png',
    ),
    Activity(
      type: 'Yoga',
      duration: '60 min',
      distance: '-',
      calories: '150 kcal',
      time: '3 days ago, 7:00 PM',
      image: 'assets/images/pp_1.png',
    ),
    Activity(
      type: 'Running',
      duration: '40 min',
      distance: '8 km',
      calories: '400 kcal',
      time: '4 days ago, 6:30 AM',
      image: 'assets/images/Workout1.png',
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
          "Activity History",
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
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
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
            child: Row(
              children: [
                // 活动图标
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    activity.image,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 15),
                // 活动信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.type,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        activity.time,
                        style: const TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Duration: ${activity.duration}',
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Distance: ${activity.distance}',
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 卡路里
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    activity.calories,
                    style: const TextStyle(
                      color: AppColors.secondaryColor1,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 活动数据模型
class Activity {
  final String type;
  final String duration;
  final String distance;
  final String calories;
  final String time;
  final String image;

  Activity({
    required this.type,
    required this.duration,
    required this.distance,
    required this.calories,
    required this.time,
    required this.image,
  });
}