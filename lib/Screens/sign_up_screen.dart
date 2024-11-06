import 'package:calculator/Auth/auth_service.dart';
import 'package:calculator/Screens/home_screen.dart';
import 'package:calculator/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();
  final _mailIdController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signup() async {
    if (_mailIdController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill in all fields");
      return;
    }
    if (!EmailValidator.validate(_mailIdController.text)) {
      Fluttertoast.showToast(msg: "Please check the email provided");
      return;
    }

    final user = await _auth.createUserWithEmailAndPassword(
      _mailIdController.text,
      _passwordController.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Fluttertoast.showToast(msg: "Signup with this mail id is already done");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _mailIdController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text("Sign Up"),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?"
                      ),
                      Text(
                        "Log In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  @override
  void dispose() {
    _mailIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
