import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth/auth_controller.dart';
import '../routes.dart';

class SettingsPage extends StatelessWidget {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF6F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Pengaturan",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Avatar + Username
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(width: 16),
                  // Menggunakan authController untuk nama user
                  Obx(() {
                    final userName =
                        authController.currentUser.value?.displayName;
                    return Text(
                      userName ?? 'User',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Option Items
            _buildOption(
              Icons.dark_mode,
              "Mode",
              textStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
            _buildOption(Icons.language, "Bahasa",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                )),
            _buildOption(Icons.download, "Download Data Bulan Sebelumnya",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                )),
            _buildOption(Icons.help_outline, "Bantuan",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                )),

            Spacer(),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                authController.logout();
                Get.toNamed(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9E1C1C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Center(
                child: Text(
                  'Keluar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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

  Widget _buildOption(IconData icon, String label, {TextStyle? textStyle}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 26),
          title: Text(
            label,
            style: textStyle ??
                TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          onTap: () {
            // TODO: Aksi saat ditekan
          },
        ),
        Divider(),
      ],
    );
  }
}
