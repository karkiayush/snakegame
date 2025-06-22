import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupProvider with ChangeNotifier {
  File? _profileImage;

  File? get profileImage => _profileImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _profileImage = File(picked.path);
      notifyListeners();
    }
  }

  void clear() {
    _profileImage = null;
    notifyListeners();
  }
}
