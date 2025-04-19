import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:ewallet/controllers/transactionController.dart';

class ControllerPengeluaran extends GetxController {
  final transactionController = Get.find<TransactionController>();

  final List<Map<String, dynamic>> expenseCategories = [
    {'icon': 'assets/icons/utensils.png', 'name': 'Makanan', 'categoryId': 'exp_food', 'color': Colors.indigo},
    {'icon': 'assets/icons/heart-rate.png', 'name': 'Kesehatan', 'categoryId': 'exp_health', 'color': Colors.green},
    {'icon': 'assets/icons/film.png', 'name': 'Hiburan', 'categoryId': 'exp_entertainment', 'color': Colors.pink},
    {'icon': 'assets/icons/basket-shopping-simple.png', 'name': 'Belanja', 'categoryId': 'exp_shopping', 'color': Colors.teal},
    {'icon': 'assets/icons/bus-alt.png', 'name': 'Transport', 'categoryId': 'exp_transport', 'color': Colors.orange},
    {'icon': 'assets/icons/broadcast-tower.png', 'name': 'Komunikasi', 'categoryId': 'exp_communication', 'color': Colors.lightBlue},
  ];

  List<PengeluaranItem> get items {
    final userId = transactionController.authController.lastUserId.value;
    final now = DateTime.now();
    return expenseCategories.map((cat) {
      final total = transactionController.filterTransactions(
        type: "1",
        userId: userId,
        categoryId: cat['categoryId'],
        month: now,
      ).fold<double>(0.0, (sum, t) => sum + t.amount);
      return PengeluaranItem(cat['icon'], cat['name'], total.toInt(), cat['color']);
    }).toList();
  }
}
