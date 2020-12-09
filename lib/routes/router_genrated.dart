import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/ui/home/home.dart';
import 'package:test_app/ui/login/login.dart';
import 'package:test_app/ui/splash/splash.dart';
import 'package:test_app/utils/router_constant.dart';

class RouterGeneretorApp {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final argus = routeSettings.arguments;

    switch (routeSettings.name) {
      case RouterConstants.INTRO_PAGE:
        return MaterialPageRoute(builder: (_) =>
            SplashScreenPage()
        );
      case RouterConstants.LOGIN_PAGE:
        return MaterialPageRoute(builder: (_) =>
            LoginPage()
        );
      case RouterConstants.HOME_PAGE:
        return MaterialPageRoute(builder: (_) =>
            HomePage()
        );

      default
          :
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child:
                  Text('No route defined for ${routeSettings.name}')),
            ));
    }
  }
}
