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
  
  // Transaction state
  final Rx<TransactionState> transactionState = TransactionState.Initial.obs;
  final RxString errorMessage = ''.obs;
  
  // Collection reference
  firestore.CollectionReference get _transactionsCollection => 
      _firestore.collection('transactions');
  
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Use the lastUserId from AuthController if available
    ever(authController.lastUserId, (String userId) {
      if (userId.isNotEmpty) {
        fetchTransactions(userId);
      } else {
        fetchLatestTransactions(limit: 5);
      }
    });
    // Initial fetch
    if (authController.lastUserId.value.isNotEmpty) {
      fetchTransactions(authController.lastUserId.value);
    } else {
      fetchLatestTransactions(limit: 5);
    }
  }

  // Add this method for guest/initial fetch
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
  
  // Create a new expense transaction
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
      
      // Add to Firestore
      await _transactionsCollection.doc(transactionId).set({
        'userId': userId,
        'categoryId': categoryId,
        'type': "1", // 1 for expense
        'title': title,
        'amount': amount,
        'description': description,
        'date': firestore.Timestamp.fromDate(date ?? DateTime.now()),
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
      
      // Add to local state
      transactions.add(transaction);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error creating expense transaction: $e');
      errorMessage.value = 'Gagal membuat transaksi pengeluaran: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }
  
  // Create a new income transaction
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
      
      // Add to Firestore
      await _transactionsCollection.doc(transactionId).set({
        'userId': userId,
        'categoryId': categoryId,
        'type': "0", // 0 for income
        'title': title,
        'amount': amount,
        'description': description,
        'date': firestore.Timestamp.fromDate(date ?? DateTime.now()),
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
      
      // Add to local state
      transactions.add(transaction);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error creating income transaction: $e');
      errorMessage.value = 'Gagal membuat transaksi pemasukan: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }
  
  // Fetch all transactions for a user
  Future<void> fetchTransactions(String userId) async {
    try {
      transactionState.value = TransactionState.Loading;
      
      final snapshot = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      
      final fetchedTransactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Create the appropriate transaction type based on 'type' field
        if (data['type'] == "0") { // Income
          return IncomeTransaction(
            id: doc.id,
            userId: data['userId'],
            categoryId: data['categoryId'],
            title: data['title'],
            amount: (data['amount'] as num).toDouble(),
            description: data['description'],
            date: (data['date'] as firestore.Timestamp).toDate(),
          );
        } else { // Expense
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
      
      // Update the observable list
      transactions.assignAll(fetchedTransactions);
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error fetching transactions: $e');
      errorMessage.value = 'Gagal mengambil data transaksi: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }
  
  // Update a transaction
  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      transactionState.value = TransactionState.Loading;
      
      await _transactionsCollection.doc(id).update(data);
      
      // Update in local state
      final index = transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        // This is a simplified approach - in a real app you might need to 
        // recreate the transaction object with updated values
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
  
  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    try {
      transactionState.value = TransactionState.Loading;
      
      await _transactionsCollection.doc(id).delete();
      
      // Remove from local state
      transactions.removeWhere((t) => t.id == id);
      
      transactionState.value = TransactionState.Success;
    } catch (e) {
      print('Error deleting transaction: $e');
      errorMessage.value = 'Gagal menghapus transaksi: ${e.toString()}';
      transactionState.value = TransactionState.Error;
      throw e;
    }
  }

  // Filtering transactions by category
  List<Transaction> getTransactionsByCategory(String categoryId) {
    return transactions.where((t) => t.categoryId == categoryId).toList();
  }
  
  // Reset transaction state
  void resetTransactionState() {
    transactionState.value = TransactionState.Initial;
    errorMessage.value = '';
  }
  
  // Get income transactions
  List<Transaction> getIncomeTransactions() {
    return transactions.where((t) => t.type == "0").toList();
  }
  
  // Get expense transactions
  List<Transaction> getExpenseTransactions() {
    return transactions.where((t) => t.type == "1").toList();
  }
  
  // Get total income
  double getTotalIncome() {
    return getIncomeTransactions().fold(0, (sum, t) => sum + t.amount);
  }
  
  // Get total expense
  double getTotalExpense() {
    return getExpenseTransactions().fold(0, (sum, t) => sum + t.amount);
  }
  
  // Get balance
  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }
}