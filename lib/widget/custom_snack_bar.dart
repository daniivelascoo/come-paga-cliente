import 'package:flutter/material.dart';

class CustomSnackBar {
  Widget content;

  CustomSnackBar({required this.content});

  SnackBar build() {
    return SnackBar(
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
        textColor: Colors.black,
      ),
      content: content,
    );
  }
}
