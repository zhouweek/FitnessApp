import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/database_helper.dart';
import 'package:fitnessapp/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitnessapp/view/home/bmi_detail_screen.dart';
import 'package:fitnessapp/view/home/widgets/workout_row.dart';
import 'package:fitnessapp/view/profile/activity_history_screen.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../common_widgets/round_button.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../notification/notification_screen.dart';
import '../../i18n/intl_extension.dart';
import '../../utils/api_service.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isLoggedIn = false;
  String? username;
  String? name;
  String? phone;
  List<WorkoutRecord> recentWorkouts = [];
  String chartMode = 'weekly';
  Map<String, Map<String, int>> chartData = {};
  bool isLoadingWorkouts = true;
  DateTime _queryTime = DateTime.now();

  double userHeight = 170.0;
  double userWeight = 60.0;

  static const List<String> workoutTypes = [
    'full_body_workout',
    'lower_body_workout',
    'ab_workout',
  ];

  static const Map<String, List<Color>> workoutTypeColors = {
    'full_body_workout': [AppColors.primaryColor1, AppColors.primaryColor2],
    'lower_body_workout': [AppColors.secondaryColor1, AppColors.secondaryColor2],
    'ab_workout': [Color(0xFF4CAF50), Color(0xFF81C784)],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLoginStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLoginStatus();
    }
  }

  void refreshData() {
    _checkLoginStatus();
  }

  double get _bmi {
    if (userHeight <= 0) return 0;
    final heightM = userHeight / 100;
    return userWeight / (heightM * heightM);
  }

  String get _bmiCategory {
    if (_bmi < 18.5) return 'underweight';
    if (_bmi < 25) return 'normal';
    if (_bmi < 30) return 'overweight';
    return 'obese';
  }

  double get _bmiProgress {
    return (_bmi / 40).clamp(0.0, 1.0);
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = ApiService().isLoggedIn;
      username = ApiService().username;
      name = ApiService().name;
      phone = prefs.getString('phone');
      userHeight = prefs.getDouble('height') ?? 170.0;
      userWeight = prefs.getDouble('weight') ?? 60.0;
    });
    if (isLoggedIn && phone != null) {
      await _loadWorkoutData();
    } else {
      setState(() {
        isLoadingWorkouts = false;
      });
    }
  }

  Future<void> _loadWorkoutData() async {
    if (phone == null) return;
    _queryTime = DateTime.now();
    setState(() {
      isLoadingWorkouts = true;
    });
    try {
      final records = await DatabaseHelper().getRecentWorkoutRecords(phone!, limit: 3);
      final data = await _loadChartData();
      setState(() {
        recentWorkouts = records;
        chartData = data;
        isLoadingWorkouts = false;
      });
    } catch (e) {
      setState(() {
        isLoadingWorkouts = false;
      });
    }
  }

  Future<Map<String, Map<String, int>>> _loadChartData() async {
    if (phone == null) return {};
    final ref = _queryTime;
    String startDate;
    if (chartMode == 'weekly') {
      final weekday = ref.weekday;
      final monday = ref.subtract(Duration(days: weekday - 1));
      startDate = _formatDate(monday);
    } else {
      startDate = '${ref.year}-${ref.month.toString().padLeft(2, '0')}-01';
    }
    final endDate = _formatDate(ref);
    return await DatabaseHelper().getWorkoutCountsByDateAndType(phone!, startDate, endDate);
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _navigateToLogin() async {
    await Navigator.pushNamed(context, LoginScreen.routeName);
    await _checkLoginStatus();
  }

  List<FlSpot> _buildSpotsForType(String workoutType) {
    final ref = _queryTime;
    List<FlSpot> spots = [];

    if (chartMode == 'weekly') {
      final weekday = ref.weekday;
      final monday = ref.subtract(Duration(days: weekday - 1));
      for (int i = 0; i < 7; i++) {
        final day = monday.add(Duration(days: i));
        final dateStr = _formatDate(day);
        final count = chartData[dateStr]?[workoutType] ?? 0;
        spots.add(FlSpot(i.toDouble(), count.toDouble()));
      }
    } else {
      final daysInMonth = DateTime(ref.year, ref.month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        final dateStr = '${ref.year}-${ref.month.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}';
        final count = chartData[dateStr]?[workoutType] ?? 0;
        spots.add(FlSpot(i.toDouble(), count.toDouble()));
      }
    }
    return spots;
  }

  double get _maxY {
    double maxVal = 3;
    for (var type in workoutTypes) {
      final spots = _buildSpotsForType(type);
      for (var spot in spots) {
        if (!spot.y.isNaN && spot.y > maxVal) maxVal = spot.y;
      }
    }
    return (maxVal + 1).ceilToDouble();
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    var style = const TextStyle(color: AppColors.grayColor, fontSize: 11);
    Widget text;
    if (chartMode == 'weekly') {
      final days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
      int idx = value.toInt();
      if (idx >= 0 && idx < 7) {
        text = Text(days[idx].intl(context), style: style);
      } else {
        text = const Text('');
      }
    } else {
      final ref = _queryTime;
      final daysInMonth = DateTime(ref.year, ref.month + 1, 0).day;
      int day = value.toInt();
      if (day > 0 && day <= daysInMonth && day % 5 == 0) {
        text = Text('$day', style: style);
      } else if (day == 1) {
        text = Text('1', style: style);
      } else {
        text = const Text('');
      }
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: text);
  }

  Widget _buildRightTitle(double value, TitleMeta meta) {
    if (value % 1 != 0 || value < 0) return const SizedBox.shrink();
    if (value == 0) {
      return const Text('0', style: TextStyle(color: AppColors.grayColor, fontSize: 11), textAlign: TextAlign.center);
    }
    return Text('${value.toInt()}', style: const TextStyle(color: AppColors.grayColor, fontSize: 11), textAlign: TextAlign.center);
  }

  List<LineChartBarData> get _lineBarsData {
    return workoutTypes.map((type) {
      final colors = workoutTypeColors[type]!;
      return LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          colors[0],
          colors[1],
        ]),
        barWidth: type == workoutTypes[0] ? 3 : 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: _buildSpotsForType(type),
      );
    }).toList();
  }

  Map<String, dynamic> _workoutRecordToMap(WorkoutRecord record) {
    return {
      "name": record.workoutType,
      "image": record.image ?? WorkoutRecord.getImageForType(record.workoutType),
      "kcal": record.calories.toInt().toString(),
      "time": record.duration.toString(),
      "progress": 0.7,
    };
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: isLoggedIn
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "welcome_back".intl(context),
                                  style: TextStyle(color: AppColors.midGrayColor, fontSize: 12),
                                ),
                                Text(
                                  (name ?? username) ?? "stefani_wong".intl(context),
                                  style: const TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 20,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            )
                          : RoundGradientButton(
                              title: "login".intl(context),
                              onPressed: _navigateToLogin,
                            ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, NotificationScreen.routeName);
                        },
                        icon: Image.asset(
                          "assets/icons/notification_icon.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                _buildBmiCard(media),
                SizedBox(height: media.width * 0.05),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "today_target".intl(context),
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        height: 30,
                        child: RoundButton(
                          title: "check".intl(context),
                          type: RoundButtonType.primaryBG,
                          onPressed: () {
                            Navigator.pushNamed(context, ActivityTrackerScreen.routeName);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "activity_status".intl(context),
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                _buildCaloriesCard(media),
                SizedBox(height: media.width * 0.1),
                _buildWorkoutProgressSection(),
                SizedBox(height: media.width * 0.02),
                _buildChartLegend(),
                SizedBox(height: media.width * 0.03),
                _buildChart(),
                SizedBox(height: media.width * 0.05),
                if (recentWorkouts.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "latest_workout".intl(context),
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ActivityHistoryScreen.routeName);
                        },
                        child: Text(
                          "see_more".intl(context),
                          style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recentWorkouts.length,
                      itemBuilder: (context, index) {
                        final record = recentWorkouts[index];
                        final wObj = _workoutRecordToMap(record);
                        return WorkoutRow(wObj: wObj);
                      }),
                  SizedBox(height: media.width * 0.1),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBmiCard(Size media) {
    return Container(
      height: media.width * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.primaryG),
          borderRadius: BorderRadius.circular(media.width * 0.065)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/icons/bg_dots.png",
            height: media.width * 0.4,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "bmi".intl(context),
                      style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _bmiCategory.intl(context),
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.7),
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: media.width * 0.05),
                    SizedBox(
                      height: 35,
                      width: 100,
                      child: RoundButton(
                          title: "view_more".intl(context),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              BmiDetailScreen.routeName,
                              arguments: {
                                'bmi': _bmi,
                                'height': userHeight,
                                'weight': userWeight,
                              },
                            );
                          }),
                    )
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {}),
                      startDegreeOffset: 250,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: _buildBmiPieSections(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildBmiPieSections() {
    final progress = _bmiProgress;
    return [
      PieChartSectionData(
        color: AppColors.secondaryColor2,
        value: progress * 100,
        title: '',
        radius: 55,
        badgeWidget: Text(
          _bmi.toStringAsFixed(1),
          style: const TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 12),
        ),
      ),
      PieChartSectionData(
        color: AppColors.whiteColor,
        value: (1 - progress) * 100,
        title: '',
        radius: 42,
      ),
    ];
  }

  Widget _buildCaloriesCard(Size media) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "calories".intl(context),
                  style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: media.width * 0.01),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                            colors: AppColors.primaryG,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)
                        .createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                  },
                  child: Text(
                    "calories_value".intl(context),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: media.width * 0.2,
            height: media.width * 0.2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: media.width * 0.16,
                  height: media.width * 0.16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Text("230kCal\n${"left".intl(context)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                SimpleCircularProgressBar(
                  startAngle: -180,
                  progressStrokeWidth: 10,
                  backStrokeWidth: 10,
                  progressColors: AppColors.primaryG,
                  backColor: Colors.grey.shade100,
                  valueNotifier: ValueNotifier(60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutProgressSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "workout_progress".intl(context),
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryG),
              borderRadius: BorderRadius.circular(15)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: chartMode,
              items: ["weekly", "monthly"]
                  .map((name) => DropdownMenuItem(
                      value: name,
                      child: Text(
                        name.intl(context),
                        style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
                      )))
                  .toList(),
              onChanged: (value) {
                if (value != null && value != chartMode) {
                  setState(() {
                    chartMode = value;
                    chartData = {};
                    isLoadingWorkouts = true;
                  });
                  _loadWorkoutData();
                }
              },
              icon: const Icon(Icons.expand_more, color: AppColors.whiteColor),
              underline: const SizedBox(),
              style: const TextStyle(color: AppColors.whiteColor, fontSize: 12),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: workoutTypes.map((type) {
        final colors = workoutTypeColors[type]!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                type.intl(context),
                style: const TextStyle(color: AppColors.grayColor, fontSize: 10),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 5),
      height: chartMode == 'weekly' ? 200 : 220,
      width: double.maxFinite,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppColors.secondaryColor1,
              tooltipRoundedRadius: 20,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  final barIndex = lineBarSpot.barIndex;
                  final typeName = barIndex < workoutTypes.length
                      ? workoutTypes[barIndex].replaceAll('_', ' ')
                      : '';
                  return LineTooltipItem(
                    "$typeName: ${lineBarSpot.y.toInt()}",
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  const FlLine(color: Colors.transparent),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 3,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: AppColors.secondaryColor1,
                    ),
                  ),
                );
              }).toList();
            },
          ),
          lineBarsData: _lineBarsData,
          minY: 0,
          maxY: _maxY,
          minX: chartMode == 'weekly' ? 0 : 0,
          maxX: chartMode == 'weekly' ? 6 : DateTime(_queryTime.year, _queryTime.month + 1, 0).day.toDouble(),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: chartMode == 'weekly' ? 1 : 5,
                getTitlesWidget: _buildBottomTitle,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: _buildRightTitle,
                showTitles: true,
                interval: 1,
                reservedSize: 35,
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 1,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.grayColor.withOpacity(0.15),
                strokeWidth: 2,
              );
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
