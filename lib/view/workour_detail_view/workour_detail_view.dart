import 'package:fitnessapp/common_widgets/round_gradient_button.dart';
import 'package:fitnessapp/i18n/intl_extension.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/api_service.dart';
import 'package:fitnessapp/utils/database_helper.dart';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/workour_detail_view/widgets/exercises_set_section.dart';
import 'package:fitnessapp/view/workour_detail_view/widgets/icon_title_next_row.dart';
import 'package:fitnessapp/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'exercises_stpe_details.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({Key? key, required this.dObj}) : super(key: key);

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {

  Future<String?> _getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  String _getWorkoutTypeFromTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('fullbody') || lowerTitle.contains('full_body')) {
      return 'full_body_workout';
    } else if (lowerTitle.contains('lowerbody') || lowerTitle.contains('lower_body')) {
      return 'lower_body_workout';
    } else if (lowerTitle.contains('ab')) {
      return 'ab_workout';
    } else if (lowerTitle.contains('upperbody') || lowerTitle.contains('upper_body')) {
      return 'full_body_workout';
    }
    return 'full_body_workout';
  }

  List latestArr = [
    {
      "image": "assets/images/Workout1.png",
      "title": "fullbody_workout",
      "time": "today_03_00pm"
    },
    {
      "image": "assets/images/Workout2.png",
      "title": "upperbody_workout",
      "time": "june_05_02_00pm"
    },
  ];

  List youArr = [
    {"image": "assets/icons/barbell.png", "title": "barbell"},
    {"image": "assets/icons/skipping_rope.png", "title": "skipping_rope"},
    {"image": "assets/icons/bottle.png", "title": "bottle_1_liters"},
  ];

  List exercisesArr = [
    {
      "name": "set_1",
      "set": [
        {"image": "assets/images/img_1.png", "title": "warm_up", "value": "05:00"},
        {
          "image": "assets/images/img_2.png",
          "title": "jumping_jack",
          "value": "12x"
        },
        {"image": "assets/images/img_1.png", "title": "skipping", "value": "15x"},
        {"image": "assets/images/img_2.png", "title": "squats", "value": "20x"},
        {
          "image": "assets/images/img_1.png",
          "title": "arm_raises",
          "value": "00:53"
        },
        {
          "image": "assets/images/img_2.png",
          "title": "rest_and_drink",
          "value": "02:00"
        },
      ],
    },
    {
      "name": "set_2",
      "set": [
        {"image": "assets/images/img_1.png", "title": "warm_up", "value": "05:00"},
        {
          "image": "assets/images/img_2.png",
          "title": "jumping_jack",
          "value": "12x"
        },
        {"image": "assets/images/img_1.png", "title": "skipping", "value": "15x"},
        {"image": "assets/images/img_2.png", "title": "squats", "value": "20x"},
        {
          "image": "assets/images/img_1.png",
          "title": "arm_raises",
          "value": "00:53"
        },
        {
          "image": "assets/images/img_2.png",
          "title": "rest_and_drink",
          "value": "02:00"
        },
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration:
      BoxDecoration(gradient: LinearGradient(colors: AppColors.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    "assets/icons/back_icon.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/icons/more_icon.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                            color: AppColors.grayColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3)),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["title"].toString().intl(context),
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].toString().intl(context)} | ${widget.dObj["time"].toString().intl(context)} | ${"calories_burn_320".intl(context)}",
                                  style: TextStyle(
                                      color: AppColors.grayColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Image.asset(
                              "assets/icons/fav_icon.png",
                              width: 15,
                              height: 15,
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      IconTitleNextRow(
                          icon: "assets/icons/time_icon.png",
                          title: "schedule_workout".intl(context),
                          time: "5/27, 09:00 AM",
                          color: AppColors.primaryColor2.withOpacity(0.3),
                          onPressed: () {
                            Navigator.pushNamed(context, WorkoutScheduleView.routeName);
                          }),
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      IconTitleNextRow(
                          icon: "assets/icons/difficulity_icon.png",
                          title: "difficulty".intl(context),
                          time: "beginner".intl(context),
                          color: AppColors.secondaryColor2.withOpacity(0.3),
                          onPressed: () {}),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "youll_need".intl(context),
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${youArr.length} ${"items".intl(context)}",
                              style:
                              TextStyle(color: AppColors.grayColor, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.5,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: youArr.length,
                            itemBuilder: (context, index) {
                              var yObj = youArr[index] as Map? ?? {};
                              return Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: media.width * 0.35,
                                        width: media.width * 0.35,
                                        decoration: BoxDecoration(
                                            color: AppColors.lightGrayColor,
                                            borderRadius:
                                            BorderRadius.circular(15)),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          yObj["image"].toString(),
                                          width: media.width * 0.2,
                                          height: media.width * 0.2,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          yObj["title"].toString().intl(context),
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ));
                            }),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "exercises".intl(context),
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${youArr.length} ${"sets".intl(context)}",
                              style:
                              TextStyle(color: AppColors.grayColor, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercisesArr.length,
                          itemBuilder: (context, index) {
                            var sObj = exercisesArr[index] as Map? ?? {};
                            return ExercisesSetSection(
                              sObj: sObj,
                              onPressed: (obj) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExercisesStepDetails(eObj: obj,),
                                  ),
                                );
                              },
                            );
                          }),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundGradientButton(title: "start_workout".intl(context), onPressed: () async {
                        if (!ApiService().isLoggedIn) {
                          await Navigator.pushNamed(context, LoginScreen.routeName);
                          if (!ApiService().isLoggedIn) return;
                        }
                        final phone = await _getPhone();
                        if (phone == null) return;
                        final now = DateTime.now();
                        final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                        final workoutType = _getWorkoutTypeFromTitle(widget.dObj["title"].toString());
                        final record = WorkoutRecord(
                          phone: phone,
                          workoutType: workoutType,
                          duration: int.tryParse(widget.dObj["time"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '30') ?? 30,
                          calories: 320.0,
                          date: dateStr,
                          image: WorkoutRecord.getImageForType(workoutType),
                        );
                        await DatabaseHelper().insertWorkoutRecord(record);
                        if (context.mounted) {
                          Navigator.pushNamed(context, FinishWorkoutScreen.routeName);
                        }
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
