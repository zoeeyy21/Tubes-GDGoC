import 'package:flutter/material.dart';
import '../models/models.dart';

class PengeluaranItemWidget extends StatelessWidget {
  final PengeluaranItem item;

  const PengeluaranItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: item.color,
          radius: 20,
          child: Image.asset(item.iconPath,
              color: const Color(0xFF000000), width: 20, height: 20),
        ),
        SizedBox(height: 8),
        Text(item.title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'poppins')),
        Text('Rp.${item.amount}',
            style: TextStyle(
                color: Colors.blue, fontSize: 12, fontFamily: 'poppins')),
      ],
    );
  }
}
