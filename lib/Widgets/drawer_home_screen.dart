import 'dart:developer';

import 'package:calculator/Provider/calculator_provider.dart';
import 'package:calculator/Provider/profile_provider.dart';
import 'package:calculator/Screens/profile_screen.dart';
import 'package:calculator/Services/database_service.dart';
import 'package:flutter/material.dart';

import '../Provider/auth_provider.dart';



class DrawerHomeScreen extends StatelessWidget {
  const DrawerHomeScreen({
    super.key,
    required this.authProvider,
    required this.calculatorProvider,
  });

  final AuthProvider authProvider;
  final CalculatorProvider calculatorProvider;

  @override
  Widget build(BuildContext context) {

    final profileProvider = ProfileProvider();

    return Drawer(
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
                              log(authProvider.user?.email??"no mail receieved");
                              DatabaseService.deleteFromDatabase(authProvider.user?.email);
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
                    profileProvider.dispose();

                    await authProvider.signout();
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (Route<dynamic> route) =>
                            route.settings.name == '/login');
                  })
        ],
      ),
    );
  }
}
