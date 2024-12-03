import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/core/utils/field_validation.dart';
import 'package:tarsheed/main.dart';
import 'package:tarsheed/modules/profile/bloc/profile_bloc.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';
import 'package:tarsheed/shared/widgets/my_text_form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: _profileListener,
          builder: (context, state) {
            _usernameController = TextEditingController(text: state.username);
            _emailController = TextEditingController(text: state.email);
            return _ProfileForm(
              formKey: _formKey,
              currentUsername: state.username,
              currentEmail: state.email,
              emailController: _emailController,
              usernameController: _usernameController,
            );
          },
        ),
      ),
    );
  }

  void _profileListener(BuildContext context, ProfileState state) {
    if (state is ProfileLoadingState) {
      _showLoadingDialog(context);
    } else if (state is ProfileSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      _showSnackBar(context, 'Profile updated successfully!');
    } else if (state is ProfileErrorState) {
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

class _ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController usernameController;

  final String currentUsername;
  final String currentEmail;

  const _ProfileForm({
    required this.formKey,
    required this.currentUsername,
    required this.currentEmail,
    required this.emailController,
    required this.usernameController,
  });

  @override
  Widget build(BuildContext context) {
    final isSafeMode = Theme.of(context).colorScheme.background ==
        AppConstants.safeBackgroundColor;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccessState && state.isSafeMode != null) {
          MyApp.globalKey.currentState?.updateTheme(
            state.isSafeMode! ? AppTheme.safeTheme : AppTheme.darkTheme,
          );
        }
      },
      child: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              MyTextFormField(
                label: "Username",
                validator: FieldValidation.validateRequired,
                controller: usernameController,
              ),
              const Gap(16),
              MyTextFormField(
                label: "Email",
                validator: FieldValidation.validateEmail,
                controller: emailController,
                type: TextInputType.emailAddress,
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Safa Mode"),
                  const Gap(16),
                  Switch(
                    value: isSafeMode,
                    onChanged: (_) {
                      context.read<ProfileBloc>().add(SaveModeToggle());
                    },
                  ),
                ],
              ),
              FilledButton(
                onPressed: () => profilePressed(context),
                child: const Text("Update Profile Info"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void profilePressed(BuildContext context) {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final username = usernameController.text.trim() == currentUsername
        ? null
        : usernameController.text.trim();
    final email = emailController.text.trim() == currentEmail
        ? null
        : emailController.text.trim();
    if (username == null && email == null) {
      _showSnackBar(context, "Your Info is already updated");
      return;
    }
    context.read<ProfileBloc>().add(ProfileSubmittedEvent(
          username: username,
          email: email,
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
