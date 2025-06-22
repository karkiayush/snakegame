import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginService(this.emailController, this.passwordController);

  Future<void> login(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);

      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/game');
      } else {
        _showError(context, "Login failed. Please check your credentials.");
      }
    } catch (e) {
      _showError(context, "Login error: ${e.toString()}");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
