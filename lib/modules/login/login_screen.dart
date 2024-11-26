import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/core/utils/field_validation.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/modules/home/blocs/routines_bloc/routines_bloc.dart';
import 'package:tarsheed/modules/home/home_screen.dart';
import 'package:tarsheed/modules/login/bloc/login_bloc.dart';
import 'package:tarsheed/modules/signup/signup_screen.dart';
import 'package:tarsheed/shared/widgets/my_text_form_field.dart';

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: _loginListener,
          child: _LoginForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
        ),
      ),
    );
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state is LoginLoadingState) {
      _showLoadingDialog(context);
    } else if (state is LoginSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      _showSnackBar(context, 'Login successful!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeBloc()..add(LoadHomeEvent()),
              ),
              BlocProvider(
                create: (context) => RoutinesBloc()..add(LoadRoutinesEvent()),
              )
            ],
            child: const HomeScreen(),
          ),
        ),
        (route) => false,
      );
    } else if (state is LoginErrorState) {
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

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginForm({
    required this.formKey,
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
              onPressed: () => loginPressed(context),
              child: const Text("Login"),
            ),
            Align(
              child: FilledButton.tonal(
                onPressed: () => signupPressed(context),
                child: const Text("Sign up"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loginPressed(BuildContext context) {
    if (!(formKey.currentState?.validate() ?? false)) return;
    context.read<LoginBloc>().add(
          LoginSubmittedEvent(
            email: emailController.text.trim(),
            password: passwordController.text,
          ),
        );
  }

  void signupPressed(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
      (route) => route.isFirst,
    );
  }
}
