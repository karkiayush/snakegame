import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupService {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _usernameController;
  final File? _profileImage;

  SignupService(this._emailController, this._passwordController,
      this._usernameController, this._profileImage);

  Future<void> signUp(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final username = _usernameController.text.trim();

    /*1. At first signup user*/
    final authResponse =
        await supabase.auth.signUp(email: email, password: password);
    final userId = authResponse.user?.id;

    /*for debugging purpose*/
    /*final session = supabase.auth.currentSession;
    final user = supabase.auth.currentUser;
    debugPrint("Current session: $session");
    debugPrint("Current user: $user");*/

    if (userId != null) {
      /*2. Sign in user to get a valid session*/
      final signInResponse = await supabase.auth
          .signInWithPassword(email: email, password: password);

      final session = supabase.auth.currentSession;
      final user = supabase.auth.currentUser;

      /*debugPrint("Session after sign-in: $session");
      debugPrint("User after sign-in: $user");*/
      /*debugPrint(
          "++++++++++++++++++++++++userId: ${userId}---------------------");*/
      /*3. Proceeding only if the session is valid*/
      if (session != null && user != null) {
        String? imageUrl;
        if (_profileImage != null) {
          final filePath = 'profile_images/$userId.png';
          await supabase.storage
              .from('profile-image')
              .upload(filePath, _profileImage);
          imageUrl =
              supabase.storage.from('profile-image').getPublicUrl(filePath);
        }

        await supabase.from('users').insert({
          'id': userId,
          'username': username,
          'profile_url': imageUrl,
        });

        Navigator.pushReplacementNamed(context, '/game');
      } else {
        // Handle error: sign in failed
        debugPrint("Sign in after signup failed. No session found.");
      }
    } else {
      debugPrint("Signup failed, no user ID returned");
    }
  }
}
