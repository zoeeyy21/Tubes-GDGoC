import 'package:ewallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewallet/controllers/auth/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  // Tampilkan popup fitur sedang dikembangkan
  void _showFeatureInDevelopmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informasi'),
          content: const Text('Fitur ini sedang dalam pengembangan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Card User Profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () => _showFeatureInDevelopmentDialog(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(() => Text(
                            authController.currentUser.value?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Mode
            _buildSettingsItem(
              context,
              icon: Icons.brightness_3,
              title: 'Mode',
            ),
            
            _buildDivider(),
            
            // Bahasa
            _buildSettingsItem(
              context,
              icon: Icons.translate,
              title: 'Bahasa',
              customIcon: Row(
                children: [
                  Text('A', style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.loop, size: 16),
                  Text('あ', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            _buildDivider(),
            
            // Download Data
            _buildSettingsItem(
              context,
              icon: Icons.download,
              title: 'Download Data Bulan Sebelumnya',
            ),
            
            _buildDivider(),
            
            // Bantuan
            _buildSettingsItem(
              context,
              icon: Icons.help_outline,
              title: 'Bantuan',
            ),
            
            _buildDivider(),
            
            const Spacer(),
            
            // Tombol Keluar
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    authController.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB30000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          final routes = [AppRoutes.settings, AppRoutes.home, AppRoutes.transaction];
          if (Get.currentRoute != routes[index]) {
            Get.offAllNamed(routes[index]);
          }
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

  // Helper untuk membuat item pengaturan
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? customIcon,
  }) {
    return InkWell(
      onTap: () => _showFeatureInDevelopmentDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: customIcon ?? Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat divider
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }
}
