import 'package:ewallet/models/transaction.dart';

class IncomeTransaction extends Transaction {
  
  IncomeTransaction({
    required String id,
    required String userId,
    required String categoryId,
    required String title,
    required double amount,
    required String description,
    required DateTime date,
  }) : super(
    id,
    userId,
    categoryId,
    "0", // 0 for income
    title,
    amount,
    description,
    date,
  );
  
}