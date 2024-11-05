import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<CalculatorProvider>(context, listen: false).setValue('=');
      },
      child: Container(
        height: 160,
        width: 70,
        child: Center(
          child: Text(
            "=",
            style: TextStyle(fontSize: 32),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.secondaryColor),
      ),
    );
  }
}
