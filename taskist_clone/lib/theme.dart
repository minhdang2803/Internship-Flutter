import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskistThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late bool _isDark;
  Future<void> swapTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == true) {
      _isDark = true;
      _selectedTheme = dark();
      prefs.setBool('isDarkTheme', true);
    } else {
      _isDark = false;
      _selectedTheme = light();
      prefs.setBool('isDarkTheme', false);
    }
    notifyListeners();
  }

  TaskistThemeProvider({required bool isDarkMode}) {
    if (isDarkMode) {
      _isDark = true;
      _selectedTheme = dark();
    } else {
      _isDark = false;
      _selectedTheme = light();
    }
  }
  bool get getDarkMode => _isDark;
  ThemeData get getTheme => _selectedTheme;
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
        brightness: Brightness.light,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith((states) {
            return Colors.black;
          }),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black45,
        ),
        textTheme: lightTextTheme,
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.black,
            secondary: Colors.grey.shade300,
            onSecondary: Colors.grey,
            error: Colors.red,
            onError: Colors.red.shade200,
            background: Colors.blue,
            onBackground: Colors.transparent,
            surface: Colors.transparent,
            onSurface: Colors.transparent));
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: darkTextTheme,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.white,
          secondary: Colors.grey.shade300,
          onSecondary: Colors.grey,
          error: Colors.red,
          onError: Colors.red.shade200,
          background: Colors.blue,
          onBackground: Colors.transparent,
          surface: Colors.transparent,
          onSurface: Colors.transparent),
    );
  }
}
