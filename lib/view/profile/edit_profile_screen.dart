import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/EditProfileScreen";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  Map<String, dynamic>? userData;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  
  DateTime? birthDate;
  String? selectedGender;
  
  final List<String> genderOptions = ['male', 'female', 'other'];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService().get('/users/me');
      if (response.containsKey('data')) {
        setState(() {
          userData = response['data'];
          _populateFormFields();
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _populateFormFields() {
    if (userData != null) {
      nameController.text = userData?['name'] ?? '';
      heightController.text = userData?['height']?.toString() ?? '';
      weightController.text = userData?['weight']?.toString() ?? '';
      selectedGender = userData?['gender'] ?? '';
      
      // 直接从用户数据中获取出生日期
      if (userData?['birthday'] != null) {
        try {
          // 处理后端返回的日期格式
          String birthdayStr = userData?['birthday'];
          if (birthdayStr != null) {
            // 解析ISO格式的日期字符串
            birthDate = DateTime.parse(birthdayStr);
          }
        } catch (e) {
          print('Error parsing birthday: $e');
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService().put(
        '/users/me',
        body: {
          'name': nameController.text.trim(),
          'height': heightController.text.isNotEmpty ? double.parse(heightController.text) : null,
          'weight': weightController.text.isNotEmpty ? double.parse(weightController.text) : null,
          'birthday': birthDate != null ? birthDate!.toIso8601String() : null,
          'gender': selectedGender,
        },
      );

      if (response.containsKey('data')) {
        // 保存成功，返回上一页
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error saving profile: $e');
      // 显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败，请检查网络连接')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
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
        title: const Text(
          "Edit Profile",
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
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: media.width * 0.05),
              RoundTextField(
                hintText: "Name",
                icon: "assets/icons/user_icon.png",
                textInputType: TextInputType.text,
                textEditingController: nameController,
              ),
              SizedBox(height: media.width * 0.05),
              RoundTextField(
                hintText: "Height (cm)",
                icon: "assets/icons/foot_icon.png",
                textInputType: TextInputType.number,
                textEditingController: heightController,
              ),
              SizedBox(height: media.width * 0.05),
              RoundTextField(
                hintText: "Weight (kg)",
                icon: "assets/icons/weight_icon.png",
                textInputType: TextInputType.number,
                textEditingController: weightController,
              ),
              SizedBox(height: media.width * 0.05),
              // 出生日期选择控件
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/calendar_icon.png",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: birthDate ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null && picked != birthDate) {
                            setState(() {
                              birthDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            birthDate != null
                                ? DateFormat('yyyy-MM-dd').format(birthDate!)
                                : "Date of Birth",
                            style: TextStyle(
                              color: birthDate != null ? AppColors.blackColor : AppColors.grayColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.grayColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width * 0.05),
              // 性别选择控件
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/gender_icon.png",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedGender,
                        hint: const Text(
                          "Gender",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        items: genderOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == "male" ? "Male" : value == "female" ? "Female" : "Other",
                              style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        underline: const SizedBox(),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width * 0.1),
              RoundGradientButton(
                title: isLoading ? "Saving..." : "Save",
                onPressed: isLoading ? null : () {
                  _saveProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
