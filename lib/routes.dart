import 'package:ewallet/pages/add_transaction_page.dart';
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
  static const String addTransaction = '/add-transaction';

  static final routes = [
    GetPage(name: start, page: () => StartPage(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
    GetPage(name: login, page: () => LoginPage(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
    GetPage(name: home, page: () => HomePage(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
    GetPage(name: transaction, page: () => TransaksiPage(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
    GetPage(name: signup, page: () => SignUp(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
    GetPage(name: AppRoutes.addTransaction,page: () => AddTransactionPage(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
    GetPage(name: settings, page: () => SettingsPage(), transition: Transition.leftToRight,transitionDuration: Duration(milliseconds: 300),),
  ];
}
