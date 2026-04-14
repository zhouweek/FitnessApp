import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/on_boarding/widgets/pager_widget.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  static String routeName = "/OnBoardingScreen";
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  List pageList = [
    {
      "title": "track_your_goal",
      "subtitle": "track_your_goal_subtitle",
      "image": "assets/images/on_board1.png"
    },
    {
      "title": "get_burn",
      "subtitle": "get_burn_subtitle",
      "image": "assets/images/on_board2.png"
    },
    {
      "title": "eat_well",
      "subtitle": "eat_well_subtitle",
      "image": "assets/images/on_board3.png"
    },
    {
      "title": "improve_sleep_quality",
      "subtitle": "improve_sleep_quality_subtitle",
      "image": "assets/images/on_board4.png"
    }
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: pageList.length,
            onPageChanged: (i) {
              setState(() {
                selectedIndex = i;
              });
            },
            itemBuilder: (context, index) {
              var temp = pageList[index] as Map? ?? {};
              return PagerWidget(obj: temp);
            },
          ),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor1,
                    value: (selectedIndex+1) / 4,
                    strokeWidth: 3,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: AppColors.primaryColor1),
                  child: IconButton(
                    icon: const Icon(
                      Icons.navigate_next,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: () {
                      if (selectedIndex < 3) {
                        selectedIndex = selectedIndex + 1;
                        pageController.animateToPage(selectedIndex,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInSine);
                      }
                      else{
                        Navigator.pushNamed(context, SignupScreen.routeName);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
