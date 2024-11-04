import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/modules/login/login_screen.dart';
import 'package:tarsheed/modules/signup/signup_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                CupertinoIcons.home,
                size: 256,
              ),
              FilledButton(
                onPressed: () => loginPressed(context),
                child: const Text("Login"),
              ),
              FilledButton.tonal(
                onPressed: () => signupPressed(context),
                child: const Text("Sign up"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void signupPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }
}
