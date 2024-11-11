import 'dart:developer';

import 'package:calculator/Provider/CalculatorProvider.dart';
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
    );
  }
}
