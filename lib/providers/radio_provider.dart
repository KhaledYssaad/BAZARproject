import 'package:flutter/material.dart';

class RadioProvider extends ChangeNotifier {
  String _selectedMethod = "email";

  String get selectedMethod => _selectedMethod;

  void setMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }
}
