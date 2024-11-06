import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/Screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
   CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // change notifier provider sets the whole app in the provider enviorment
      create: (context) => CalculatorProvider(), //passing the actual provider
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("Calculator App")),
          ),
          body: LoginScreen(),
        ),
      ),
    );
  }
}
