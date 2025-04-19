import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TransaksiPage extends StatelessWidget {
  final List<Map<String, dynamic>> transaksi = [
    {
      'tanggal': '1 April 2025',
      'deskripsi': 'Beli Paket Data',
      'kategori': 'Komunikasi',
      'jumlah': 100000
    },
    {
      'tanggal': '2 April 2025',
      'deskripsi': 'Beli Beras, Telur, Bumbu bumbu',
      'kategori': 'Makan & Minum',
      'jumlah': 100000
    },
    {
      'tanggal': '2 April 2025',
      'deskripsi': 'Bensin Motor',
      'kategori': 'Transportasi',
      'jumlah': 20000
    },
    {
      'tanggal': '3 April 2025',
      'deskripsi': 'Beli Perlengkapan Kuliah',
      'kategori': 'Belanja',
      'jumlah': 35000
    },
    {
      'tanggal': '7 April 2025',
      'deskripsi': 'Beli Bensin Motor',
      'kategori': 'Transportasi',
      'jumlah': 20000
    },
    {
      'tanggal': '7 April 2025',
      'deskripsi': 'Nongkrong',
      'kategori': 'Hiburan',
      'jumlah': 25000
    },
    {
      'tanggal': '8 April 2025',
      'deskripsi': 'Beli Snack',
      'kategori': 'Belanja',
      'jumlah': 30000
    },
  ];

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
                      child: const Text(
                        'Pengeluaran Bulan ini\nRp.740.000',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'Kategori',
                          items: const [
                            DropdownMenuItem(
                              value: 'Kategori',
                              child: Text('Kategori'),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: transaksi.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = transaksi[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['tanggal'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                item['deskripsi'],
                                style: const TextStyle(fontFamily: 'Poppins'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rp.${item['jumlah'].toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    item['kategori'],
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
                      ),
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
              ? '/settings'
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
}