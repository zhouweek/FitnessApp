import 'package:fitnessapp/main.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity/activity_screen.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/DashboardScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  int selectTab = 0;
  final GlobalKey<State<HomeScreen>> _homeScreenKey = GlobalKey();
  final GlobalKey<State<UserProfile>> _userProfileKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _refreshCurrentTab();
  }

  void _refreshCurrentTab() {
    if (selectTab == 0) {
      final homeState = _homeScreenKey.currentState;
      if (homeState != null) {
        (homeState as dynamic).refreshData();
      }
    } else if (selectTab == 2) {
      final profileState = _userProfileKey.currentState;
      if (profileState != null) {
        (profileState as dynamic).refreshData();
      }
    }
  }

  void _onTabChanged(int index) {
    if (mounted) {
      setState(() {
        selectTab = index;
      });
      if (index == 0) {
        final homeState = _homeScreenKey.currentState;
        if (homeState != null) {
          (homeState as dynamic).refreshData();
        }
      } else if (index == 2) {
        final profileState = _userProfileKey.currentState;
        if (profileState != null) {
          (profileState as dynamic).refreshData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: IndexedStack(
        index: selectTab,
        children: [
          HomeScreen(key: _homeScreenKey),
          const ActivityScreen(),
          UserProfile(key: _userProfileKey),
        ],
      ),
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, -2))
            ]),
        child: Row(
          children: [
            Expanded(
              child: TabButton(
                icon: "assets/icons/home_icon.png",
                selectIcon: "assets/icons/home_select_icon.png",
                isActive: selectTab == 0,
                onTap: () => _onTabChanged(0),
              ),
            ),
            Expanded(
              child: TabButton(
                icon: "assets/icons/activity_icon.png",
                selectIcon: "assets/icons/activity_select_icon.png",
                isActive: selectTab == 1,
                onTap: () => _onTabChanged(1),
              ),
            ),
            Expanded(
              child: TabButton(
                icon: "assets/icons/user_icon.png",
                selectIcon: "assets/icons/user_select_icon.png",
                isActive: selectTab == 2,
                onTap: () => _onTabChanged(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton({
    Key? key,
    required this.icon,
    required this.selectIcon,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isActive ? selectIcon : icon,
              width: 25,
              height: 25,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: isActive ? 8 : 12),
            Visibility(
              visible: isActive,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.secondaryG),
                    borderRadius: BorderRadius.circular(2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
