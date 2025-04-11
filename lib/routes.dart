import 'package:get/get.dart';
import 'pages/start.dart';
import 'pages/homepage.dart';

class AppRoutes {
  static const start = '/';
  static const home = '/home';

  static final routes = [
    GetPage(name: start, page: () => StartPage()),
    GetPage(name: home, page: () => HomePage()),
  ];
}
