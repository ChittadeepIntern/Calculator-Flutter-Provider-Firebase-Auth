import 'dart:developer';

import 'package:calculator/Constants/app_colors.dart';
import 'package:calculator/Provider/calculator_provider.dart';
import 'package:calculator/Provider/auth_provider.dart';
import 'package:calculator/Screens/widgets_data.dart';
import 'package:calculator/Widgets/cal_button.dart';
import 'package:calculator/Widgets/drawer_home_screen.dart';
import 'package:calculator/Widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final calculatorProvider = Provider.of<CalculatorProvider>(
        context, listen: false);

    final padding = EdgeInsets.symmetric(horizontal: 20, vertical: 30);
    final decoration = BoxDecoration(
        color: AppColors.primaryColor, borderRadius: BorderRadius.circular(30));

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white, foregroundColor: Colors.black),
      drawer: DrawerHomeScreen(
          authProvider: authProvider, calculatorProvider: calculatorProvider),
      body: SingleChildScrollView(  // Wrap body with SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                textEditingController: calculatorProvider.textEditingController),
            Container(
              width: double.infinity,
              padding: padding,
              decoration: decoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => buttonList[index]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        4, (index) => buttonList[index + 4]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        4, (index) => buttonList[index + 8]),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  3, (index) => buttonList[index + 12]),
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  3, (index) => buttonList[index + 15]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      CalculateButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
