import 'package:flutter/material.dart';
import 'package:login/main.dart';

class NavigateUtil {
  void navigateToView(String routeName,
      {Object? arguments, bool clearStack = false}) {
    if (clearStack) {
      // Usa pushAndRemoveUntil per rimuovere tutte le schermate precedenti
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        (Route<dynamic> route) =>
            false, // Rimuove tutte le schermate dallo stack
        arguments: arguments,
      );
    } else {
      // Naviga normalmente senza rimuovere le schermate precedenti
      navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
    }
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
