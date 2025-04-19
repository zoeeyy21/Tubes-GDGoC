import 'package:ewallet/models/transaction.dart';

class ExpenseTransaction extends Transaction {
  
  ExpenseTransaction({
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
    "1", // 1 for expense
    title,
    amount,
    description,
    date,
  );
  
}