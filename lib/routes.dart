import 'package:get/get.dart';
import 'pages/start.dart';
import 'pages/homepage.dart';
import 'pages/login.dart';
import 'pages/settings.dart';
import 'pages/transaction.dart';
import 'pages/signup.dart';

class AppRoutes {
  static const start = '/';
  static const home = '/home';
  static const login = '/login';
  static const signup = '/signup';
  static const settings = '/settings';
  static const transaction = '/transaction';

  static final routes = [
    GetPage(name: start, page: () => StartPage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: signup, page:() => SignUp()),
    GetPage(name: home, page: () => HomePage()),
  ];
}
