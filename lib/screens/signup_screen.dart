import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snakegame/providers/signup_provider.dart';
import 'package:snakegame/services/signup_service.dart';
import 'package:snakegame/widgets/app_bar_widget.dart';
import 'package:snakegame/widgets/button_widget.dart';
import 'package:snakegame/widgets/profile_image_picker_widget.dart';
import 'package:snakegame/widgets/text_field_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _handleSignup() {
    /*since this below Provider.of(context) is not a part of widget tree rebuild process that is why we set the listen to false so that it doesn't listen to changes.
    *
    * Since we're using this provider inside of a callback i.e. onPressed: _handleSignup, so we don't want to listen and rebuild our widget everytime the provider updates as we're using the value just once*/
    final signupProvider = Provider.of<SignupProvider>(context, listen: false);

    final service = SignupService(
      _emailController,
      _passwordController,
      _usernameController,
      signupProvider.profileImage,
    );
    service.signUp(context);
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignupProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBarWidget.name("Signup", 24, FontWeight.bold).getAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ProfileImagePicker(
              image: signupProvider.profileImage,
              onTap: () => signupProvider.pickImage(),
            ),
            const SizedBox(height: 20),
            TextFieldWidget(controller: _usernameController, label: "Username"),
            const SizedBox(height: 16),
            TextFieldWidget(controller: _emailController, label: "Email"),
            const SizedBox(height: 16),
            TextFieldWidget(
                controller: _passwordController,
                label: "Password",
                obscureText: true),
            const SizedBox(height: 24),

            /*signup button*/
            ButtonWidget(
              text: "Create Account",
              onPressed: _handleSignup,
            ),

            /*already have account button*/
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text(
                'Already have an account? Log in',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
