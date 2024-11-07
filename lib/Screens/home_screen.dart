import 'dart:developer';

import 'package:calculator/Auth/auth_service.dart';
import 'package:calculator/Constants/app_colors.dart';
import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/Screens/login_screen.dart';
import 'package:calculator/Screens/widgets_data.dart';
import 'package:calculator/Widgets/cal_button.dart';
import 'package:calculator/Widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();

    final screenHeight = MediaQuery.sizeOf(context).height * 0.6;
    final padding = EdgeInsets.symmetric(horizontal: 25, vertical: 30);
    final decoration = BoxDecoration(
        color: AppColors.primaryColor, borderRadius: BorderRadius.circular(30));

    return Consumer<CalculatorProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              ListTile(
                title: Text("View Profile"),
              ),
              ListTile(
                title: Text("Delete Account"),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content:
                              Text("Do you really want to delete your account"),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  log("Pressed on logout");
                                  await _auth.deleteUserAccount(provider.password);
                                  provider.textEditingController.clear();
                                  provider.password = null;
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
                  onTap: ()  async {
                        log("Pressed on logout");
                        provider.textEditingController.clear();
                        provider.password = null;
                        await _auth.signout();
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
                textEditingController: provider.textEditingController),
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
    });
  }
}
