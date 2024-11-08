import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/Screens/home_screen.dart';
import 'package:calculator/Screens/login_screen.dart';
import 'package:calculator/Screens/profile_screen.dart';
import 'package:calculator/Screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        // change notifier provider sets the whole app in the provider enviorment
        providers: [
          ChangeNotifierProvider(create: (_) => CalculatorProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider())
        ], //passing the actual provider
        child: MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/signup': (context) => SignUpScreen(),
            '/profile': (context) => ProfileScreen()
          },
          initialRoute: AuthProvider().isAuthenticated?'/home':'/login',
        ));
  }
}
