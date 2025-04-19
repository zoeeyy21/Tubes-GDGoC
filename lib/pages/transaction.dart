import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewallet/controllers/transactionController.dart'; 
import 'package:ewallet/models/enum.dart';
import 'package:ewallet/models/transaction.dart'; 

class TransaksiPage extends StatelessWidget {
  final TransactionController transactionController = Get.find<TransactionController>();

  // Income Categories
  final incomeCategories = [
    {'id': 'inc_salary', 'name': 'Gaji'},
    {'id': 'inc_bonus', 'name': 'Bonus'},
    {'id': 'inc_investment', 'name': 'Investasi'},
    {'id': 'inc_gift', 'name': 'Hadiah'},
    {'id': 'inc_other', 'name': 'Lainnya'},
  ];

  // Expense Categories
  final expenseCategories = [
    {'id': 'exp_food', 'name': 'Makanan'},
    {'id': 'exp_health', 'name': 'Kesehatan'},
    {'id': 'exp_entertainment', 'name': 'Hiburan'},
    {'id': 'exp_shopping', 'name': 'Belanja'},
    {'id': 'exp_transport', 'name': 'Transport'},
    {'id': 'exp_communication', 'name': 'Komunikasi'},
    {'id': 'exp_other', 'name': 'Lainnya'},
  ];

  String getCategoryName(String categoryId) {
    final allCategories = [...incomeCategories, ...expenseCategories];
    final found = allCategories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': categoryId},
    );
    return found['name'] ?? categoryId;
  }

  final RxString selectedCategory = 'Kategori'.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1455FD),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Transaksi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            // Force GetX to track the transactions observable
                            final _ = transactionController.transactions;
                            return Text(
                              'Pemasukan\nRp.${transactionController.getMonthlyIncome().toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            );
                          }),
                          Obx(() {
                            // Force GetX to track the transactions observable
                            final _ = transactionController.transactions;
                            return Text(
                              'Pengeluaran\nRp.${transactionController.getMonthlyExpense().toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            );
                          })
                        ]
                      )
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory.value,
                          items: [
                            DropdownMenuItem(
                              value: 'Kategori',
                              child: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // Income header (disabled)
                            DropdownMenuItem<String>(
                              enabled: false,
                              child: Text('Pemasukan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ),
                            ...incomeCategories.map((cat) => DropdownMenuItem(
                                  value: cat['id'],
                                  child: Text(cat['name']!),
                                )),
                            // Expense header (disabled)
                            DropdownMenuItem<String>(
                              enabled: false,
                              child: Text('Pengeluaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ),
                            ...expenseCategories.map((cat) => DropdownMenuItem(
                                  value: cat['id'],
                                  child: Text(cat['name']!),
                                )),
                          ],
                          onChanged: (value) {
                            if (value != null && value != 'Income Categories' && value != 'Expense Categories') {
                              selectedCategory.value = value;
                            }
                          },
                        ),
                      )),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(() {
                        if (transactionController.transactionState.value == TransactionState.Loading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        // Use filterTransactions for category and month filtering
                        final now = DateTime.now();
                        final filteredTransactions = selectedCategory.value == 'Kategori'
                            ? transactionController.filterTransactions(month: now)
                            : transactionController.filterTransactions(
                                categoryId: selectedCategory.value,
                                month: now,
                              );
                        if (filteredTransactions.isEmpty) {
                          return Center(child: Text('No transactions found.', style: TextStyle(fontFamily: 'Poppins')));
                        }
                        return ListView.separated(
                          itemCount: filteredTransactions.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = filteredTransactions[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(item.date),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          _buildActionButton(
                                            icon: Icons.edit,
                                            color: Colors.blue,
                                            onTap: () => _editTransaction(context, item),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildActionButton(
                                            icon: Icons.delete,
                                            color: Colors.red,
                                            onTap: () => _confirmDelete(context, item),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Menampilkan judul transaksi
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.description,
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp.${item.amount.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: item.type == "0" ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      getCategoryName(item.categoryId),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          Get.toNamed(index == 0
              ? '/pengaturan'
              : index == 1
                  ? '/home'
                  : '/transaction');
        },
        selectedItemColor: const Color(0xFF000000),
        unselectedItemColor: const Color(0xFF000000),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/settings.png', width: 24),
            label: 'Pengaturan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 24),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/receipt.png', width: 24),
            label: 'Transaksi',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // Widget untuk tombol aksi dengan tampilan yang lebih baik
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
    );
  }

  // Move all helper methods here, outside of the build method
  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
  
  void _confirmDelete(BuildContext context, Transaction transaction) {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus Transaksi'),
        content: Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _deleteTransaction(transaction.id);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  void _deleteTransaction(String id) async {
    try {
      await transactionController.deleteTransaction(id);
      Get.snackbar(
        'Sukses',
        'Transaksi berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 10,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 10,
        duration: Duration(seconds: 3),
      );
    }
  }
  
  void _editTransaction(BuildContext context, Transaction transaction) {
    final TextEditingController titleController = TextEditingController(text: transaction.title);
    final TextEditingController descController = TextEditingController(text: transaction.description);
    final TextEditingController amountController = TextEditingController(text: transaction.amount.toString());
    final RxString category = transaction.categoryId.obs;
    
    Get.dialog(
      AlertDialog(
        title: Text('Edit Transaksi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: category.value,
                decoration: InputDecoration(labelText: 'Kategori'),
                items: (transaction.type == "1" ? expenseCategories : incomeCategories)
                    .map((cat) => DropdownMenuItem(
                          value: cat['id'],
                          child: Text(cat['name']!),
                        ))
                    .toList(),
                onChanged: (val) => category.value = val ?? '',
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty || amountController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Judul dan total tidak boleh kosong',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount <= 0) {
                Get.snackbar(
                  'Error',
                  'Total harus lebih dari 0',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              
              Get.back();
              _updateTransaction(
                transaction.id,
                {
                  'title': titleController.text,
                  'description': descController.text,
                  'amount': amount,
                  'categoryId': category.value,
                },
              );
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
  
  void _updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      await transactionController.updateTransaction(id, data);
      Get.snackbar(
        'Sukses',
        'Transaksi berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 10,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 10,
        duration: Duration(seconds: 3),
      );
    }
  }
}