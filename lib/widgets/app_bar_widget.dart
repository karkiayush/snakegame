import 'package:flutter/material.dart';

class AppBarWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  AppBarWidget.name(this.title, this.fontSize, this.fontWeight);

  AppBar getAppBar() {
    return AppBar(
      title:  Text(
        title,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
      centerTitle: true,
    );
  }
}
