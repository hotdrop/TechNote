import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryColorDark = Color.fromARGB(255, 232, 181, 248);
  static const Color _primaryColorLight = Colors.blueAccent;
  static const Color defaultTagColor = Color.fromARGB(255, 227, 227, 227);

  static const String appName = 'Technology Note';
  static const double defaultTextSize = 14;

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Note Sans JP',
    primaryColor: _primaryColorDark,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
        color: _primaryColorDark,
      ),
    ),
    iconTheme: const IconThemeData(
      color: _primaryColorDark,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      selectedIconTheme: IconThemeData(color: _primaryColorDark),
      selectedLabelTextStyle: TextStyle(color: _primaryColorDark),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _primaryColorDark,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColorDark,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColorDark,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColorDark,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(_primaryColorDark),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all(_primaryColorDark),
      thumbColor: MaterialStateProperty.all(_primaryColorDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColorDark,
        foregroundColor: Colors.black,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryColorDark,
    ),
  );

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Note Sans JP',
    primaryColor: _primaryColorLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryColorLight,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(
      color: _primaryColorLight,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColorLight,
      foregroundColor: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(_primaryColorLight),
    ),
  );

  ///
  /// RoundedLoadingButtonはサードパーティライブラリのボタンなのでThemeが適用されない。
  /// そのためこの関数を使ってカラーを指定すること
  ///
  static Color? getRoundedLoadingButtonColor(BuildContext context) {
    return Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve(MaterialState.values.toSet());
  }
}
