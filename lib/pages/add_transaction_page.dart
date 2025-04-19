import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:ewallet/controllers/transactionController.dart';
import 'package:ewallet/controllers/auth/auth_controller.dart';

class AddTransactionPage extends StatelessWidget {
  final TransactionController transaksiController = Get.find<TransactionController>();
  final AuthController authController = Get.find<AuthController>();

  final RxString type = '1'.obs; // "1" for expense, "0" for income
  final RxString category = ''.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final List<Map<String, String>> incomeCategories = [
    {'id': 'inc_salary', 'name': 'Gaji'},
    {'id': 'inc_bonus', 'name': 'Bonus'},
    {'id': 'inc_investment', 'name': 'Investasi'},
    {'id': 'inc_gift', 'name': 'Hadiah'},
    {'id': 'inc_other', 'name': 'Lainnya'},
  ];
  
  final List<Map<String, String>> expenseCategories = [
    {'id': 'exp_food', 'name': 'Makanan'},
    {'id': 'exp_health', 'name': 'Kesehatan'},
    {'id': 'exp_entertainment', 'name': 'Hiburan'},
    {'id': 'exp_shopping', 'name': 'Belanja'},
    {'id': 'exp_transport', 'name': 'Transport'},
    {'id': 'exp_communication', 'name': 'Komunikasi'},
    {'id': 'exp_other', 'name': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
        backgroundColor: Color(0xFF1455FD),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Obx(() {
              // Explicitly access the observable values
              final typeValue = type.value;
              final categoryValue = category.value;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jenis Transaksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Pengeluaran'),
                          value: '1',
                          groupValue: typeValue,
                          onChanged: (val) => type.value = val!,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Pemasukan'),
                          value: '0',
                          groupValue: typeValue,
                          onChanged: (val) => type.value = val!,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kategori',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: categoryValue.isEmpty ? null : categoryValue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    hint: Text('Pilih Kategori'),
                    items: (typeValue == '1' ? expenseCategories : incomeCategories)
                        .map((cat) => DropdownMenuItem(
                              value: cat['id'],
                              child: Text(cat['name']!),
                            ))
                        .toList(),
                    onChanged: (val) => category.value = val ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kategori harus dipilih';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Judul',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan judul transaksi',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan deskripsi (opsional)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Jumlah',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan jumlah',
                      prefixText: 'Rp. ',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Jumlah harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1455FD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Get user ID from current user or last user ID
                          final userId = authController.currentUser.value?.uid ?? 
                                        authController.lastUserId.value;
                          
                          if (userId.isEmpty) {
                            Get.snackbar(
                              'Error', 
                              'Anda harus login terlebih dahulu',
                              backgroundColor: Colors.red.withOpacity(0.1),
                              colorText: Colors.red,
                            );
                            return;
                          }
                          
                          final amount = double.tryParse(amountController.text) ?? 0.0;
                          
                          try {
                            if (type.value == '1') {
                              await transaksiController.createExpenseTransaction(
                                userId: userId,
                                categoryId: category.value,
                                title: titleController.text,
                                amount: amount,
                                description: descController.text,
                              );
                            } else {
                              await transaksiController.createIncomeTransaction(
                                userId: userId,
                                categoryId: category.value,
                                title: titleController.text,
                                amount: amount,
                                description: descController.text,
                              );
                            }
                            Get.back();
                            Get.snackbar(
                              'Sukses', 
                              'Transaksi berhasil ditambahkan',
                              backgroundColor: Colors.green.withOpacity(0.1),
                              colorText: Colors.green,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Error', 
                              'Gagal menambah transaksi: ${e.toString()}',
                              backgroundColor: Colors.red.withOpacity(0.1),
                              colorText: Colors.red,
                            );
                          }
                        }
                      },
                      child: Text(
                        'Simpan Transaksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}