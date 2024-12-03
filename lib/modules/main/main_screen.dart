import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/modules/login/login_screen.dart';
import 'package:tarsheed/modules/signup/signup_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          PositionedDirectional(
              start: 0,
              end: 0,
              child: Image.asset(
                "assets/jic_logo_remove_bg.png",
                width: 128,
                height: 128,
              )),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Icon(
                        CupertinoIcons.home,
                        size: 128,
                      ),
                    ),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      "Home Energy Conservation",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                    const Gap(32),
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
          ),
        ],
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
