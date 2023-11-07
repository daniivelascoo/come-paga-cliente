import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color.fromARGB(255, 244, 67, 54);
  static const green = Color.fromARGB(255, 0, 150, 136);
  static const primaryGradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 244, 3, 3),
        Color.fromARGB(255, 250, 145, 145)
      ],
      end: AlignmentDirectional.bottomCenter,
      begin: AlignmentDirectional.topCenter);

  static final ThemeData theme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          return Colors.transparent;
        },
      ),
    )),
    scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStatePropertyAll(primaryColor.withOpacity(0.5))),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor; // Color cuando está seleccionado
        } else {
          return primaryColor; // Color cuando no está seleccionado
        }
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Colors.transparent;
            },
          ),
          fixedSize: MaterialStateProperty.all(const Size(150, 30)),
          shadowColor: MaterialStateProperty.all(Colors.black),
          backgroundColor: MaterialStateProperty.all(primaryColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)))),
    ),
    colorScheme: const ColorScheme.light(background: primaryColor)
        .copyWith(background: primaryColor),
  );
}
