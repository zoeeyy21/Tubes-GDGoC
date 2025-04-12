import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class ControllerPengeluaran extends GetxController {
  var items = <PengeluaranItem>[
    PengeluaranItem('assets/icons/utensils.png', 'Makanan', 300000, Colors.indigo),
    PengeluaranItem('assets/icons/heart-rate.png', 'Kesehatan', 40000, Colors.green),
    PengeluaranItem('assets/icons/film.png', 'Hiburan', 100000, Colors.pink),
    PengeluaranItem('assets/icons/basket-shopping-simple.png', 'Belanja', 100000, Colors.teal),
    PengeluaranItem('assets/icons/bus-alt.png', 'Transport', 100000, Colors.orange),
    PengeluaranItem('assets/icons/broadcast-tower.png', 'Komunikasi', 100000, Colors.lightBlue),
  ].obs;
}
