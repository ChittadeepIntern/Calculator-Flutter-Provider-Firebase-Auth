import 'dart:developer';

import 'package:calculator/Constants/app_colors.dart';
import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/Screens/widgets_data.dart';
import 'package:calculator/Widgets/cal_button.dart';
import 'package:calculator/Widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final calculatorProvider = Provider.of<CalculatorProvider>(context, listen: false);

    final screenHeight = MediaQuery.sizeOf(context).height * 0.6;
    final padding = EdgeInsets.symmetric(horizontal: 25, vertical: 30);
    final decoration = BoxDecoration(
        color: AppColors.primaryColor, borderRadius: BorderRadius.circular(30));

      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              ListTile(
                title: Text("View Profile"),
                textColor: Colors.black,
                onTap: ()=> Navigator.pushNamed(context, '/profile')
              ),
              ListTile(
                title: Text("Delete Account"),
                textColor: Colors.black,
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content:
                              Text("Do you really want to delete your account"),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  log("Pressed on logout");
                                  await authProvider.deleteUserAccount(calculatorProvider.password);
                                  calculatorProvider.textEditingController.clear();
                                  calculatorProvider.password = null;
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (Route<dynamic> route) =>
                                        route.settings.name == '/login',
                                  );
                                },
                                child: Text("yes")),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("no"))
                          ],
                        )),
              ),
              ListTile(
                  title: Text("Logout"),
                  textColor: Colors.black,
                  onTap: ()  async {
                        log("Pressed on logout");
                        calculatorProvider.textEditingController.clear();
                        calculatorProvider.password = null;
                        await authProvider.signout();
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (Route<dynamic> route) =>
                                route.settings.name == '/login');
                      })
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                textEditingController: calculatorProvider.textEditingController),
            Container(
              height: screenHeight,
              width: double.infinity,
              padding: padding,
              decoration: decoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) => buttonList[index])),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          List.generate(4, (index) => buttonList[index + 4])),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          List.generate(4, (index) => buttonList[index + 8])),
                  Row(
                    children: [
                      Expanded(
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  3, (index) => buttonList[index + 12])),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  3, (index) => buttonList[index + 15]))
                        ]),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CalculateButton(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }
}
