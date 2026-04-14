import 'package:fitnessapp/i18n/intl_extension.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/notification/widgets/notification_row.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/NotificationScreen";

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notificationArr = [
    {
      "image": "assets/images/Workout1.png",
      "title": "hey_its_time_for_lunch",
      "time": "about_1_minutes_ago"
    },
    {
      "image": "assets/images/Workout2.png",
      "title": "dont_miss_your_lowerbody_workout",
      "time": "about_3_hours_ago"
    },
    {
      "image": "assets/images/Workout3.png",
      "title": "hey_lets_add_some_meals",
      "time": "about_3_hours_ago"
    },
    {
      "image": "assets/images/Workout1.png",
      "title": "congratulations_you_have_finished",
      "time": "29_may"
    },
    {
      "image": "assets/images/Workout2.png",
      "title": "hey_its_time_for_lunch",
      "time": "8_april"
    },
    {
      "image": "assets/images/Workout3.png",
      "title": "ups_you_have_missed_your_workout",
      "time": "8_april"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
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
          title: Text(
            "notification".intl(context),
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
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
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        body: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            itemBuilder: ((context, index) {
              var nObj = notificationArr[index] as Map? ?? {};
              return NotificationRow(nObj: nObj);
            }),
            separatorBuilder: (context, index) {
              return Divider(
                color: AppColors.grayColor.withOpacity(0.5),
                height: 1,
              );
            },
            itemCount: notificationArr.length));
  }
}
