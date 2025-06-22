import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ProfileImagePicker({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        backgroundImage: image != null ? FileImage(image!) : null,
        child: image == null
            ? Icon(Icons.add_a_photo, color: primaryColor, size: 30)
            : null,
      ),
    );
  }
}
