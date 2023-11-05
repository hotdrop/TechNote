import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color.fromARGB(255, 227, 47, 237);
  static const Color primaryLightColor = Color.fromARGB(255, 232, 181, 248);
  static const Color defaultTagColor = Color.fromARGB(255, 227, 227, 227);

  static const String appName = 'Technology Note';
  static const double defaultTextSize = 14;

  static final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Note Sans JP',
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(
      color: primaryLightColor,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      selectedIconTheme: IconThemeData(color: primaryLightColor),
      selectedLabelTextStyle: TextStyle(color: primaryLightColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLightColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLightColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return primaryLightColor;
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLightColor,
        foregroundColor: Colors.black,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),
  );
}
