// widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snakegame/providers/obscure_text_provider.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final obscureProvider = Provider.of<ObscureTextProvider>(context);
    final bool isObscure = obscureText ? obscureProvider.isObscure : false;

    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        suffixIcon: obscureText
            ? IconButton(
                onPressed: () {
                  obscureProvider.updateObsecureText(!isObscure);
                },
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),
    );
  }
}
