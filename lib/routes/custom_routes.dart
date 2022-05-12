import 'package:ai_project/page/home/home_page.dart';
import 'package:ai_project/page/login/login_page.dart';
import 'package:ai_project/routes/screen_argument.dart';
import 'package:ai_project/routes/slide_left_route.dart';
import 'package:flutter/material.dart';

class CustomRoutes {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    late ScreenArguments arg;
    final Object? arguments = settings.arguments;
    if (arguments != null) {
      arg = arguments as ScreenArguments;
    }
    switch (settings.name) {
      case LoginPage.routeName:
        return SlideLeftRoute(const LoginPage());
      case HomePage.routeName:
        return SlideLeftRoute(HomePage(data: arg));
      default:
        throw ('this route name does not exist');
    }
  }
}
