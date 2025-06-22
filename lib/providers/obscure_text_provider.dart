import 'package:flutter/material.dart';

class ObscureTextProvider extends ChangeNotifier {
  bool _isObscureText = true;

  bool get isObscure => _isObscureText;

  void updateObsecureText(bool updateValue) {
    _isObscureText = updateValue;
    notifyListeners();
  }
}
