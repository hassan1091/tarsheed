import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/helper/field_validation.dart';
import 'package:tarsheed/screens/login/login_screen.dart';
import 'package:tarsheed/widgets/my_text_form_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              MyTextFormField(
                label: "Username",
                hint: "user123",
                validator: FieldValidation.validateRequired,
                controller: _usernameController,
                type: TextInputType.text,
                autofocus: true,
              ),
              const Gap(16),
              MyTextFormField(
                label: "Email",
                hint: "user123@mail.com",
                validator: FieldValidation.validateEmail,
                controller: _emailController,
                type: TextInputType.emailAddress,
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
              FilledButton.tonal(
                onPressed: signupPressed,
                child: const Text("Sign up"),
              ),
              Align(
                child: FilledButton(
                  onPressed: loginPressed,
                  child: const Text("Login"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void signupPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
  }
}
