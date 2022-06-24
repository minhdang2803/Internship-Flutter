import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  bool _darkmode = false;
  bool get getdarkMode => _darkmode;
  void setdarkMode(bool darkMode) async {
    _darkmode = darkMode;
    notifyListeners();
  }
}
