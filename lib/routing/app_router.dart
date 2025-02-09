import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/get_started_screen.dart';
import 'package:login/pages/logged_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
      case '/guest':
        return MaterialPageRoute(
            builder: (_) => GetStartedScreen(
                  title: "Test login",
                ));

      case '/customer':
        return MaterialPageRoute(builder: (_) => LoggedScreen());
      // MultiBlocProvider(providers: [], child: LoggedScreen()));

      default:
        return MaterialPageRoute(
            builder: (_) => GetStartedScreen(
                  title: "Test login",
                ));
    }
  }

  void dispose() {}
}
