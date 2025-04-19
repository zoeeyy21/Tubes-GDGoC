import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/incomeTransaction.dart';
import '../models/expenseTransaction.dart';
import '../models/enum.dart';
import 'package:ewallet/controllers/auth/auth_controller.dart';

class TransactionController extends GetxController {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  var transactions = <Transaction>[].obs;
  final uuid = Uuid();

  final Rx<TransactionState> transactionState = TransactionState.Initial.obs;
  final RxString errorMessage = ''.obs;

  firestore.CollectionReference get _transactionsCollection =>
      _firestore.collection('transactions');

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    ever(authController.lastUserId, (String userId) {
      if (userId.isNotEmpty) {
        fetchTransactions(userId);
      } else {
        fetchLatestTransactions(limit: 5);
      }
    });
    if (authController.lastUserId.value.isNotEmpty) {
      fetchTransactions(authController.lastUserId.value);
    } else {
      fetchLatestTransactions(limit: 5);
    }
  }

  Future<void> fetchLatestTransactions({int limit = 5}) async {
    try {
      transactionState.value = TransactionState.Loading;
      final snapshot = await _transactionsCollection
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      final fetchedTransactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['type'] == "0") {
          return IncomeTransaction(
            id: doc.id,
            userId: data['userId'],
            categoryId: data['categoryId'],
            title: data['title'],
            amount: (data['amount'] as num).toDouble(),
            description: data['description'],
            date: (data['date'] as firestore.Timestamp).toDate(),
          );
        } else {
          return ExpenseTransaction(
            id: doc.id,
            userId: data['userId'],
            categoryId: data['categoryId'],
            title: data['title'],
            amount: (data['amount'] as num).toDouble(),
            description: data['description'],
            date: (data['date'] as firestore.Timestamp).toDate(),
          );
        }
      }).toList();
      transactions.assignAll(fetchedTransactions);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error fetching latest transactions: $e');
      errorMessage.value = 'Gagal mengambil transaksi terbaru: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  Future<void> createExpenseTransaction({
    required String userId,
    required String categoryId,
    required String title,
    required double amount,
    required String description,
    DateTime? date,
  }) async {
    try {
      transactionState.value = TransactionState.Loading;
      final transactionId = uuid.v4();
      final transaction = ExpenseTransaction(
        id: transactionId,
        userId: userId,
        categoryId: categoryId,
        title: title,
        amount: amount,
        description: description,
        date: date ?? DateTime.now(),
      );
      await _transactionsCollection.doc(transactionId).set({
        'userId': userId,
        'categoryId': categoryId,
        'type': "1",
        'title': title,
        'amount': amount,
        'description': description,
        'date': firestore.Timestamp.fromDate(date ?? DateTime.now()),
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
      transactions.add(transaction);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error creating expense transaction: $e');
      errorMessage.value = 'Gagal membuat transaksi pengeluaran: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  Future<void> createIncomeTransaction({
    required String userId,
    required String categoryId,
    required String title,
    required double amount,
    required String description,
    DateTime? date,
  }) async {
    try {
      transactionState.value = TransactionState.Loading;
      final transactionId = uuid.v4();
      final transaction = IncomeTransaction(
        id: transactionId,
        userId: userId,
        categoryId: categoryId,
        title: title,
        amount: amount,
        description: description,
        date: date ?? DateTime.now(),
      );
      await _transactionsCollection.doc(transactionId).set({
        'userId': userId,
        'categoryId': categoryId,
        'type': "0",
        'title': title,
        'amount': amount,
        'description': description,
        'date': firestore.Timestamp.fromDate(date ?? DateTime.now()),
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
      transactions.add(transaction);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error creating income transaction: $e');
      errorMessage.value = 'Gagal membuat transaksi pemasukan: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  Future<void> fetchTransactions(String userId) async {
    try {
      transactionState.value = TransactionState.Loading;
      final snapshot = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      final fetchedTransactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['type'] == "0") {
          return IncomeTransaction(
            id: doc.id,
            userId: data['userId'],
            categoryId: data['categoryId'],
            title: data['title'],
            amount: (data['amount'] as num).toDouble(),
            description: data['description'],
            date: (data['date'] as firestore.Timestamp).toDate(),
          );
        } else {
          return ExpenseTransaction(
            id: doc.id,
            userId: data['userId'],
            categoryId: data['categoryId'],
            title: data['title'],
            amount: (data['amount'] as num).toDouble(),
            description: data['description'],
            date: (data['date'] as firestore.Timestamp).toDate(),
          );
        }
      }).toList();
      transactions.assignAll(fetchedTransactions);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error fetching transactions: $e');
      errorMessage.value = 'Gagal mengambil data transaksi: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      transactionState.value = TransactionState.Loading;
      await _transactionsCollection.doc(id).update(data);
      final index = transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        await fetchTransactions(transactions[index].userId);
      }
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error updating transaction: $e');
      errorMessage.value = 'Gagal memperbarui transaksi: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      transactionState.value = TransactionState.Loading;
      await _transactionsCollection.doc(id).delete();
      transactions.removeWhere((t) => t.id == id);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error deleting transaction: $e');
      errorMessage.value = 'Gagal menghapus transaksi: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  // Generalized filtering function
  List<Transaction> filterTransactions({
    String? type, // "0" for income, "1" for expense
    String? userId,
    String? categoryId,
    DateTime? month,
  }) {
    return transactions.where((t) {
      final matchesType = type == null || t.type == type;
      final matchesUser = userId == null || t.userId == userId;
      final matchesCategory = categoryId == null || t.categoryId == categoryId;
      final matchesMonth = month == null ||
          (t.date.month == month.month && t.date.year == month.year);
      return matchesType && matchesUser && matchesCategory && matchesMonth;
    }).toList();
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(String categoryId) {
    return filterTransactions(categoryId: categoryId);
  }

  // Get total expense by category for a specific user this month
  double getTotalExpenseByCategoryForUser(String userId, String categoryId) {
    final now = DateTime.now();
    return filterTransactions(
      type: "1",
      userId: userId,
      categoryId: categoryId,
      month: now,
    ).fold(0.0, (sum, t) => sum + t.amount);
  }

  void resetTransactionState() {
    transactionState.value = TransactionState.Initial;
    errorMessage.value = '';
  }

  // Get income transactions
  List<Transaction> getIncomeTransactions() {
    return filterTransactions(type: "0");
  }

  // Get expense transactions
  List<Transaction> getExpenseTransactions() {
    return filterTransactions(type: "1");
  }

  // Get total income
  double getTotalIncome() {
    return getIncomeTransactions().fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get total expense
  double getTotalExpense() {
    return getExpenseTransactions().fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get balance
  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  // Get total income for the current month
  double getMonthlyIncome() {
    final now = DateTime.now();
    return filterTransactions(type: "0", month: now)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get total expense for the current month
  double getMonthlyExpense() {
    final now = DateTime.now();
    return filterTransactions(type: "1", month: now)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}