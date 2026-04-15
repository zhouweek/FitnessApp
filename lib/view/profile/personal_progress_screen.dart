import 'package:fitnessapp/i18n/intl_extension.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalProgressScreen extends StatefulWidget {
  static const String routeName = '/PersonalProgressScreen';

  const PersonalProgressScreen({Key? key}) : super(key: key);

  @override
  State<PersonalProgressScreen> createState() => _PersonalProgressScreenState();
}

class _PersonalProgressScreenState extends State<PersonalProgressScreen> {
  int selectedPeriod = 0;
  bool isLoading = true;

  final List<String> periods = ['weekly', 'monthly', 'yearly'];

  int totalWorkouts = 0;
  int totalDurationMinutes = 0;
  double totalCalories = 0;
  Map<String, Map<String, int>> chartData = {};

  static const int weeklyGoal = 7;
  static const int monthlyDurationGoal = 600;
  static const int monthlyCalorieGoal = 10000;
  static const int monthlyWorkoutGoal = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');
    if (phone == null) {
      setState(() { isLoading = false; });
      return;
    }

    final db = DatabaseHelper();
    final now = DateTime.now();

    String startDate;
    if (selectedPeriod == 0) {
      final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
      startDate = '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
    } else if (selectedPeriod == 1) {
      startDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
    } else {
      startDate = '${now.year}-01-01';
    }
    final endDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final workoutCount = await db.getWorkoutCountByDateRange(phone, '', startDate, endDate);
    final duration = await db.getTotalDurationByDateRange(phone, startDate, endDate);
    final calories = await db.getTotalCaloriesByDateRange(phone, startDate, endDate);
    final data = await db.getWorkoutCountsByDateAndType(phone, startDate, endDate);

    setState(() {
      totalWorkouts = workoutCount;
      totalDurationMinutes = duration;
      totalCalories = calories;
      chartData = data;
      isLoading = false;
    });
  }

  List<ProgressStat> get stats => [
    ProgressStat(
      title: 'total_workouts',
      value: totalWorkouts.toString(),
      unit: 'times',
      progress: (totalWorkouts / monthlyWorkoutGoal).clamp(0.0, 1.0),
      icon: Icons.fitness_center,
    ),
    ProgressStat(
      title: 'total_duration',
      value: (totalDurationMinutes / 60).toStringAsFixed(1),
      unit: 'hours',
      progress: (totalDurationMinutes / monthlyDurationGoal).clamp(0.0, 1.0),
      icon: Icons.timer_outlined,
    ),
    ProgressStat(
      title: 'calories_burned',
      value: totalCalories.toInt().toString(),
      unit: 'kcal',
      progress: (totalCalories / monthlyCalorieGoal).clamp(0.0, 1.0),
      icon: Icons.local_fire_department_outlined,
    ),
    ProgressStat(
      title: 'active_days',
      value: chartData.length.toString(),
      unit: 'days',
      progress: (chartData.length / weeklyGoal).clamp(0.0, 1.0),
      icon: Icons.calendar_today,
    ),
  ];

  List<WeeklyData> get weeklyDataList {
    final now = DateTime.now();
    final days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    List<WeeklyData> result = [];
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: now.weekday - 1 - i));
      final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      int dayTotal = 0;
      final dayData = chartData[dateStr];
      if (dayData != null) {
        for (var count in dayData.values) {
          dayTotal += count;
        }
      }
      result.add(WeeklyData(day: days[i], value: dayTotal));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "personal_progress".intl(context),
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
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: List.generate(periods.length, (index) {
                        bool isSelected = selectedPeriod == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPeriod = index;
                                isLoading = true;
                              });
                              _loadData();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(colors: AppColors.primaryG)
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                periods[index].intl(context),
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
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: media.width / (media.width * 0.55),
                    ),
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final stat = stats[index];
                      return Container(
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
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: index % 2 == 0
                                        ? AppColors.primaryG
                                        : AppColors.secondaryG),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(stat.icon,
                                  color: AppColors.whiteColor, size: 18),
                            ),
                            const Spacer(),
                            Text(
                              stat.title.intl(context),
                              style: const TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  stat.value,
                                  style: const TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    stat.unit.intl(context),
                                    style: const TextStyle(
                                      color: AppColors.grayColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrayColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                widthFactor: stat.progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: index % 2 == 0
                                            ? AppColors.primaryG
                                            : AppColors.secondaryG),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "workout_frequency".intl(context),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: media.width * 0.45,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],
                    ),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (_getMaxBarValue() + 1).ceilToDouble(),
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value % 1 != 0 || value == 0) return const SizedBox();
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    color: AppColors.grayColor,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 25,
                              getTitlesWidget: (value, meta) {
                                int idx = value.toInt();
                                if (idx < 0 || idx >= weeklyDataList.length) {
                                  return const SizedBox();
                                }
                                return Text(
                                  weeklyDataList[idx].day.intl(context),
                                  style: const TextStyle(
                                    color: AppColors.grayColor,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: AppColors.grayColor.withOpacity(0.15),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: weeklyDataList.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.value.toDouble(),
                                gradient: LinearGradient(
                                  colors: AppColors.primaryG,
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                width: 20,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  double _getMaxBarValue() {
    double maxVal = 3;
    for (var d in weeklyDataList) {
      if (d.value > maxVal) maxVal = d.value.toDouble();
    }
    return maxVal;
  }
}

class ProgressStat {
  final String title;
  final String value;
  final String unit;
  final double progress;
  final IconData icon;

  ProgressStat({
    required this.title,
    required this.value,
    required this.unit,
    required this.progress,
    required this.icon,
  });
}

class WeeklyData {
  final String day;
  final int value;

  WeeklyData({required this.day, required this.value});
}
