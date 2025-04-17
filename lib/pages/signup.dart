import 'package:ewallet/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes.dart';
/* import 'package:ewallet/models/enum.dart'; */

class SignUp extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  SignUp({super.key});

  bool isValidEmail(String email) {
    // Regex pattern untuk validasi email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1455FD), Color(0xFF003399)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Image.asset('assets/icons/angle-small-right.png',
                          width: 30, height: 30),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'E-Wallet',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Buat Akun',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 140),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: usernameController,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'nama pengguna',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'kata sandi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Validasi email
                        if (!isValidEmail(emailController.text.trim())) {
                          Get.snackbar(
                            'Format Email Salah',
                            'Silakan masukkan alamat email yang valid',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                            duration: Duration(seconds: 3),
                          );
                          return;
                        }

                        // Validasi password
                        if (passwordController.text.trim().length < 6) {
                          Get.snackbar(
                            'Password Terlalu Pendek',
                            'Password harus minimal 6 karakter',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                            duration: Duration(seconds: 3),
                          );
                          return;
                        }

                        // Validasi username
                        if (usernameController.text.trim().isEmpty) {
                          Get.snackbar(
                            'Username Kosong',
                            'Silakan masukkan nama pengguna',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                            duration: Duration(seconds: 3),
                          );
                          return;
                        }

                        // Lanjut proses registrasi jika semua validasi berhasil
                        authController.register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          usernameController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002F91),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Daftar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'sudah punya akun? ',
                          style: TextStyle(
                            color: Color(0xB3FFFFFF),
                            fontFamily: 'poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.login);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'masuk',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
