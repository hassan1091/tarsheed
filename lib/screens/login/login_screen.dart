import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/helper/field_validation.dart';
import 'package:tarsheed/screens/home/home_screen.dart';
import 'package:tarsheed/screens/signup/signup_screen.dart';
import 'package:tarsheed/widgets/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarsheed'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              MyTextFormField(
                label: "Email",
                hint: "user123@mail.com",
                validator: FieldValidation.validateEmail,
                controller: _emailController,
                type: TextInputType.emailAddress,
                autofocus: true,
              ),
              const Gap(16),
              MyTextFormField(
                label: "Password",
                hint: "*****",
                validator: FieldValidation.validatePassword,
                controller: _passwordController,
                isPassword: true,
              ),
              const Gap(16),
              FilledButton(
                onPressed: loginPressed,
                child: const Text("Login"),
              ),
              Align(
                child: FilledButton.tonal(
                  onPressed: signupPressed,
                  child: const Text("Sign up"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginPressed() {
    // if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void signupPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
      (route) => route.isFirst,
    );
  }
}
