import 'package:fitnessapp/i18n/intl_extension.dart';
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
      type: 'running',
      durationValue: '30',
      durationUnit: 'min',
      distanceValue: '5',
      distanceUnit: 'km',
      caloriesValue: '300',
      caloriesUnit: 'kcal',
      time: 'today_8_30_am',
      image: 'assets/images/Workout1.png',
    ),
    Activity(
      type: 'cycling',
      durationValue: '45',
      durationUnit: 'min',
      distanceValue: '15',
      distanceUnit: 'km',
      caloriesValue: '450',
      caloriesUnit: 'kcal',
      time: 'yesterday_6_00_pm',
      image: 'assets/images/Workout2.png',
    ),
    Activity(
      type: 'swimming',
      durationValue: '20',
      durationUnit: 'min',
      distanceValue: '1',
      distanceUnit: 'km',
      caloriesValue: '200',
      caloriesUnit: 'kcal',
      time: '2_days_ago_10_00_am',
      image: 'assets/images/Workout3.png',
    ),
    Activity(
      type: 'yoga',
      durationValue: '60',
      durationUnit: 'min',
      distanceValue: '-',
      distanceUnit: '',
      caloriesValue: '150',
      caloriesUnit: 'kcal',
      time: '3_days_ago_7_00_pm',
      image: 'assets/images/pp_1.png',
    ),
    Activity(
      type: 'running',
      durationValue: '40',
      durationUnit: 'min',
      distanceValue: '8',
      distanceUnit: 'km',
      caloriesValue: '400',
      caloriesUnit: 'kcal',
      time: '4_days_ago_6_30_am',
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
        title: Text(
          "activity_history".intl(context),
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
                        activity.type.intl(context),
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        activity.time.intl(context),
                        style: const TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '${"duration".intl(context)}: ${activity.durationValue} ${activity.durationUnit.intl(context)}',
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '${"distance".intl(context)}: ${activity.distanceValue}${activity.distanceUnit.isNotEmpty ? ' ${activity.distanceUnit.intl(context)}' : ''}',
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
                    '${activity.caloriesValue} ${activity.caloriesUnit.intl(context)}',
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
  final String durationValue;
  final String durationUnit;
  final String distanceValue;
  final String distanceUnit;
  final String caloriesValue;
  final String caloriesUnit;
  final String time;
  final String image;

  Activity({
    required this.type,
    required this.durationValue,
    required this.durationUnit,
    required this.distanceValue,
    required this.distanceUnit,
    required this.caloriesValue,
    required this.caloriesUnit,
    required this.time,
    required this.image,
  });
}