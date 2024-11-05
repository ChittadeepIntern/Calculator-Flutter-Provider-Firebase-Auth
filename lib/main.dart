import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

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
          body: HomeScreen(),
        ),
      ),
    );
  }
}
