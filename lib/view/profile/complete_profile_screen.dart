import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/api_service.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../../i18n/intl_extension.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String? selectedGender;
  DateTime? selectedDate;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 准备请求数据
      final Map<String, dynamic> profileData = {
        'gender': selectedGender,
        'age': selectedDate != null ? _calculateAge(selectedDate!) : null,
        'weight': weightController.text.isNotEmpty ? double.parse(weightController.text) : null,
        'height': heightController.text.isNotEmpty ? double.parse(heightController.text) : null,
      };

      // 调用API保存个人资料
      await ApiService().put('/users/me', body: profileData);

      // 保存成功，跳转到下一页
      Navigator.pushNamed(context, YourGoalScreen.routeName);
    } catch (e) {
      print('Error saving profile: $e');
      // 显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('save_failed'.intl(context))),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Column(
              children: [
                Image.asset("assets/images/complete_profile.png", width: media.width),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "complete_profile".intl(context),
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "help_us_know_you".intl(context),
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                            "assets/icons/gender_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          )),
                      Expanded(child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedGender,
                          items: ["male", "female"].map((name) => DropdownMenuItem<String>(
                            value: name,
                            child: Text(
                              name == "male" ? "male".intl(context) : "female".intl(context), style: const TextStyle(color: AppColors.grayColor, fontSize: 14),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                          isExpanded: true,
                          hint: Text("choose_gender".intl(context), style: const TextStyle(color: AppColors.grayColor, fontSize: 12)),
                        ),
                      )),
                      SizedBox(width: 8,)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset(
                              "assets/icons/calendar_icon.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: AppColors.grayColor,
                            )),
                        Expanded(
                          child: Text(
                            selectedDate != null 
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : "date_of_birth".intl(context),
                            style: TextStyle(
                              color: selectedDate != null ? AppColors.blackColor : AppColors.grayColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 8,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                RoundTextField(
                  hintText: "your_weight".intl(context),
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.number,
                  textEditingController: weightController,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  hintText: "your_height".intl(context),
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.number,
                  textEditingController: heightController,
                ),
                SizedBox(height: 15),
                RoundGradientButton(
                  title: isLoading ? "saving".intl(context) : "next".intl(context),
                  onPressed: isLoading ? null : () {
                    _saveProfile();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
