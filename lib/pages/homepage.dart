import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F3F3),
      body: Stack(
        children: [
          // Background biru lengkung
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Color(0xFF1455FD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // Isi konten
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'E-Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'poppins',
                    ),
                  ),
                  SizedBox(height: 20),

                  // Box putih
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Pengeluaran Bulan ini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rp.740.000',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'poppins',
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1455FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed('/tambahTransaksi');
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Baru saja melakukan transaksi?'),
                        ),
                      ],
                    ),
                  ),

                  // Tambahan konten di bawah sini
                  SizedBox(height: 20),
                  // Misal: Daftar pengeluaran, komentar, dll
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Get.toNamed() bisa kamu tambah di sini
        },
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
      ),
    );
  }
}
