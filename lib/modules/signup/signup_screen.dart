import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/core/utils/field_validation.dart';
import 'package:tarsheed/modules/login/login_screen.dart';
import 'package:tarsheed/modules/signup/bloc/signup_bloc.dart';
import 'package:tarsheed/shared/widgets/my_text_form_field.dart';

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
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: BlocListener<SignupBloc, SignupState>(
          listener: _signupListener,
          child: _SignupForm(
            formKey: _formKey,
            usernameController: _usernameController,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
        ),
      ),
    );
  }

  void _signupListener(BuildContext context, SignupState state) {
    if (state is SignupLoadingState) {
      _showLoadingDialog(context);
    } else if (state is SignupSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      _showSnackBar(context, 'Signup successful!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (state is SignupErrorState) {
      Navigator.pop(context); // Close the loading dialog
      _showSnackBar(context, state.message);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignupForm({
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            MyTextFormField(
              label: "Username",
              hint: "user123",
              validator: FieldValidation.validateRequired,
              controller: usernameController,
              type: TextInputType.text,
              autofocus: true,
            ),
            const Gap(16),
            MyTextFormField(
              label: "Email",
              hint: "user123@mail.com",
              validator: FieldValidation.validateEmail,
              controller: emailController,
              type: TextInputType.emailAddress,
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
            FilledButton.tonal(
              onPressed: () => _signupPressed(context),
              child: const Text("Sign up"),
            ),
            Align(
              child: FilledButton(
                onPressed: () => _loginPressed(context),
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signupPressed(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      context.read<SignupBloc>().add(
            SignupSubmittedEvent(
              username: usernameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text,
            ),
          );
    }
  }

  void _loginPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
