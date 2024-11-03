import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/helper/field_validation.dart';
import 'package:tarsheed/widgets/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarsheed'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            MyTextFormField(
              label: "Email",
              hint: "user123@mail.com",
              validator: FieldValidation.validateEmail,
              controller: emailController,
              type: TextInputType.emailAddress,
              autofocus: true,
            ),
            const Gap(16),
            MyTextFormField(
              label: "Password",
              hint: "*****",
              validator: FieldValidation.validatePassword,
              controller: passwordController,
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
    );
  }

  void loginPressed() {}

  void signupPressed() {}
}
