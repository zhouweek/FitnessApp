import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/api_service.dart';
import 'package:fitnessapp/utils/api_config.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../profile/complete_profile_screen.dart';
import '../../i18n/intl_extension.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = '密码和确认密码不匹配';
      });
      return;
    }

    if (!isCheck) {
      setState(() {
        errorMessage = '请同意隐私政策和使用条款';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await ApiService().post(
        ApiConfig.authRegister,
        body: {
          'phone': phoneController.text,
          'password': passwordController.text,
          'username': phoneController.text, // 默认用户名就是手机号
        },
        withAuth: false,
      );

      if (response.containsKey('data')) {
        // 注册成功，跳转到完善个人资料页面
        Navigator.pushNamed(context, CompleteProfileScreen.routeName);
      }
    } catch (e) {
      setState(() {
        errorMessage = e is ApiException ? e.message : '注册失败，请检查网络连接';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "hey_there".intl(context),
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "create_account".intl(context),
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                    hintText: "phone".intl(context),
                    icon: "assets/icons/message_icon.png",
                    textInputType: TextInputType.phone,
                    textEditingController: phoneController),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  hintText: "password".intl(context),
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: !isPasswordVisible,
                  rightIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            isPasswordVisible ? "assets/icons/show_pwd_icon.png" : "assets/icons/hide_pwd_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          ))),
                  textEditingController: passwordController,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  hintText: "confirm_password".intl(context),
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: !isConfirmPasswordVisible,
                  rightIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            isConfirmPasswordVisible ? "assets/icons/show_pwd_icon.png" : "assets/icons/hide_pwd_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          ))),
                  textEditingController: confirmPasswordController,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        icon: Icon(
                          isCheck
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank_outlined,
                          color: AppColors.grayColor,
                        )),

                    Expanded(
                      child: Text(
                          "accept_terms".intl(context),
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 10,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                RoundGradientButton(
                  title: isLoading ? "registering".intl(context) : "register".intl(context),
                  onPressed: isLoading ? null : () { _register(); },
                ),

                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: "already_have_account".intl(context),
                            ),
                            TextSpan(
                                text: "login".intl(context),
                                style: TextStyle(
                                    color: AppColors.secondaryColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
