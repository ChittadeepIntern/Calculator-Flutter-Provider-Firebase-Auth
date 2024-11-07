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

  final _formKey = GlobalKey<FormState>();

  final _mailIdController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signup(String mailId, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
      mailId,
      password,
    );

    if (user != null) {
      Navigator.pushReplacementNamed(
        context,'/home'
      );
    } else {
      Fluttertoast.showToast(msg: "Signup with this mail id is already done");
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _signup(_mailIdController.text, _passwordController.text);
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
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _mailIdController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter Email Address";

                      if (!EmailValidator.validate(value))
                        return "Please check the email provided";
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value){
                      if (value == null || value.isEmpty)
                        return "Please enter Password";
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Sign Up"),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/login'
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
