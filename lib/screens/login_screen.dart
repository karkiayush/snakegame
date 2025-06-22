import 'package:flutter/material.dart';
import 'package:snakegame/services/login_service.dart';
import 'package:snakegame/widgets/app_bar_widget.dart';
import 'package:snakegame/widgets/button_widget.dart';
import 'package:snakegame/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    final loginService = LoginService(_emailController, _passwordController);
    loginService.login(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBarWidget.name("Login", 24, FontWeight.bold).getAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            TextFieldWidget(controller: _emailController, label: "Email"),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _passwordController,
              label: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ButtonWidget(text: "Login", onPressed: _handleLogin),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/signup'),
              child: Text(
                "Don't have an account? Sign up",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}