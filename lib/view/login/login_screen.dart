import 'package:fitnessapp/utils/api_config.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/api_service.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import '../../i18n/intl_extension.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await ApiService().post(
        ApiConfig.authLogin,
        body: {
          'phone': phoneController.text,
          'password': passwordController.text,
        },
        withAuth: false,
      );

      if (response.containsKey('data') && response['data'].containsKey('access_token') && response['data'].containsKey('refresh_token')) {
        await ApiService().saveToken(
          response['data']['access_token'],
          response['data']['refresh_token'],
        );
        // 保存用户信息
        if (response['data'].containsKey('user') && response['data']['user'] is Map<String, dynamic>) {
          await ApiService().saveUserInfo(response['data']['user']);
        }
        // 登录成功，跳转到主页面
        Navigator.pushNamed(context, DashboardScreen.routeName);
      } else {
        setState(() {
          errorMessage = '登录失败，服务器返回格式错误';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e is ApiException ? e.message : '登录失败，请检查网络连接';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                width: media.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: media.width*0.03,
                    ),
                    Text(
                      "hey_there".intl(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: media.width*0.01),
                    Text(
                      "welcome_back".intl(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                  hintText: "phone".intl(context),
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.phone,
                  textEditingController: phoneController),
              SizedBox(height: media.width*0.05),
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
              SizedBox(height: media.width*0.03),
              Text("forgot_password".intl(context),
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 10,
                  )),
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
              const Spacer(),
              RoundGradientButton(
                title: isLoading ? "logging_in".intl(context) : "login".intl(context),
                onPressed: isLoading ? null : () { _login(); },
              ),

              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupScreen.routeName);
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
                            text: "dont_have_account".intl(context),
                          ),
                          TextSpan(
                              text: "register".intl(context),
                              style: TextStyle(
                                  color: AppColors.secondaryColor1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
