import 'package:flutter/material.dart';
import 'package:dsg/main.dart';
import 'package:dsg/pages/account.dart';
import 'package:dsg/pages/login.dart';
import 'package:dsg/pages/register.dart';
import 'package:dsg/pages/cart.dart';
import 'package:dsg/pages/product_details.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginForm());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterForm());
      case '/details':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => ProductDetails(
              id: args,
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
