import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller.dart';
import '../widgets/widget.dart';
import '../controllers/auth/auth_controller.dart';
import '../routes.dart';
import 'package:ewallet/models/enum.dart';

class HomePage extends StatelessWidget {
  final pengeluaranController = Get.put(ControllerPengeluaran());
  final authController =
      Get.find<AuthController>(); // Dapatkan instance AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F3F3),
      body: Stack(
        children: [
          // BACKGROUND BIRU MELENGKUNG
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Color(0xFF1455FD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(38),
                bottomRight: Radius.circular(38),
              ),
            ),
          ),

          // BAGIAN HEADER
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('E-Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w800,
                          )),
                      // untuk test fitur aja
                      // Tombol Logout/Login
                      Obx(() {
                        if (authController.authState.value ==
                            AuthState.Authenticated) {
                          return IconButton(
                            icon: Icon(Icons.logout, color: Colors.white),
                            onPressed: () {
                              // Konfirmasi sebelum logout
                              Get.dialog(
                                AlertDialog(
                                  title: Text('Logout'),
                                  content:
                                      Text('Apakah Anda yakin ingin keluar?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppRoutes.home); // Tutup dialog
                                        authController
                                            .logout(); // Panggil metode logout
                                      },
                                      child: Text('Ya',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.login, color: Colors.white),
                            onPressed: () {
                              Get.toNamed(AppRoutes.login);
                            },
                          );
                        }
                      })
                    ],
                  ),
                  SizedBox(height: 10),
                  // Nama user sekarang akan menggunakan data dari AuthController
                  Obx(() {
                    final userName =
                        authController.currentUser.value?.displayName;
                    return Text(
                        userName != null
                            ? 'Welcome $userName!'
                            : 'Welcome Guest!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'poppins',
                        ));
                  }),
                  SizedBox(height: 20),

                  // BAGIAN CARD PUTIH
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(25),
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
                          Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 63, right: 63, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E5E5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    textAlign: TextAlign.start,
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
                              Get.toNamed('/transaction');
                            },
                            label: Text(
                              'Baru saja melakukan transaksi?',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                  color: Colors.white),
                            ),
                            icon:
                                Icon(Icons.add, size: 18, color: Colors.white),
                          ),
                        ],
                      )),

                  SizedBox(height: 20),

                  // BODY
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Daftar Pengeluaran',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins',
                              )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // ICON ICON
                  Obx(() {
                    final items = pengeluaranController.items;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: items
                              .sublist(0, 3)
                              .map((item) => Expanded(
                                    child: PengeluaranItemWidget(item: item),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: items
                              .sublist(3)
                              .map((item) => Expanded(
                                    child: PengeluaranItemWidget(item: item),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 30),

                  //KOMENTAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Komentar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      //BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          Get.toNamed(index == 0
              ? '/settings'
              : index == 1
                  ? '/home'
                  : '/transaction');
        },
        selectedItemColor: Color(0xFF000000),
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
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
