import 'package:fitnessapp/i18n/intl_extension.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BmiDetailScreen extends StatefulWidget {
  static const String routeName = '/BmiDetailScreen';

  final double bmi;
  final double height;
  final double weight;

  const BmiDetailScreen({
    Key? key,
    required this.bmi,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  State<BmiDetailScreen> createState() => _BmiDetailScreenState();
}

class _BmiDetailScreenState extends State<BmiDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bmiAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bmiAnimation = Tween<double>(begin: 0, end: widget.bmi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _bmiCategory {
    if (widget.bmi < 18.5) return 'underweight';
    if (widget.bmi < 25) return 'normal';
    if (widget.bmi < 30) return 'overweight';
    return 'obese';
  }

  double get _bmiProgress {
    return (widget.bmi / 40).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "bmi_detail".intl(context),
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColors.primaryG),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "your_bmi".intl(context),
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _bmiAnimation,
                    builder: (context, child) {
                      return Text(
                        _bmiAnimation.value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _bmiCategory.intl(context),
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "bmi_scale".intl(context),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildScaleBar(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildScaleLabel('underweight'.intl(context),
                          const Color(0xFF42A5F5), '<18.5'),
                      _buildScaleLabel('normal'.intl(context),
                          const Color(0xFF66BB6A), '18.5-24.9'),
                      _buildScaleLabel('overweight'.intl(context),
                          const Color(0xFFFFA726), '25-29.9'),
                      _buildScaleLabel('obese'.intl(context),
                          const Color(0xFFEF5350), '≥30'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "body_data".intl(context),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildDataRow("height".intl(context),
                      "${widget.height.toStringAsFixed(0)} ${"cm".intl(context)}"),
                  const Divider(height: 25),
                  _buildDataRow("weight".intl(context),
                      "${widget.weight.toStringAsFixed(1)} ${"kg".intl(context)}"),
                  const Divider(height: 25),
                  _buildDataRow("bmi".intl(context),
                      widget.bmi.toStringAsFixed(1)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "health_advice".intl(context),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getAdvice(),
                    style: const TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleBar() {
    return Stack(
      children: [
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF42A5F5),
                Color(0xFF66BB6A),
                Color(0xFFFFA726),
                Color(0xFFEF5350),
              ],
              stops: [0.0, 0.4625, 0.625, 1.0],
            ),
          ),
        ),
        Positioned(
          left: _bmiProgress * (MediaQuery.of(context).size.width - 90),
          child: Container(
            width: 3,
            height: 18,
            margin: const EdgeInsets.only(top: -3),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScaleLabel(String label, Color color, String range) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          range,
          style: const TextStyle(
            color: AppColors.grayColor,
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.grayColor,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getAdvice() {
    if (widget.bmi < 18.5) {
      return 'underweight_advice'.intl(context);
    } else if (widget.bmi < 25) {
      return 'normal_advice'.intl(context);
    } else if (widget.bmi < 30) {
      return 'overweight_advice'.intl(context);
    } else {
      return 'obese_advice'.intl(context);
    }
  }
}
