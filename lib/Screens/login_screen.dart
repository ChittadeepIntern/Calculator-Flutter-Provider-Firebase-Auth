import 'package:calculator/Services/auth_service.dart';
import 'package:calculator/Provider/CalculatorProvider.dart';
import 'package:calculator/Screens/home_screen.dart';
import 'package:calculator/Screens/sign_up_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final _mailIdController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(String mailId, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final calculatorProvider = Provider.of<CalculatorProvider>(context, listen: false);

    final user = await authProvider.signInUserWithEmailAndPassword(mailId, password);

    if (user != null) {
      calculatorProvider.password =
          password;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please check your credentials")),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _login(_mailIdController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                    controller: _mailIdController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter Email Address";

                      if (!EmailValidator.validate(_mailIdController.text))
                        return "Please check the email provided";
                    }),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter Password";
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Sign In"),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      Text("Sign Up", style: TextStyle(color: Colors.blue))
                    ],
                  ),
                ),
              ],
            ),
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
