import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes.dart';
import 'package:ewallet/controllers/auth/auth_controller.dart';
import 'package:ewallet/models/enum.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  LoginPage({super.key});

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
                    IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.home);
                      },
                      icon: Image.asset(
                        'assets/icons/angle-small-right.png',
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
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
                            'Masuk',
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
                        hintStyle: const TextStyle(
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
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'kata sandi',
                        hintStyle: const TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Tombol Login dengan Integrasi Auth dan Obx ---
                    Obx(() => ElevatedButton(
                          // Logika onPressed untuk memanggil controller & handle state
                          onPressed: authController.authState.value ==
                                  AuthState.Loading
                              ? null // Nonaktifkan saat loading
                              : () {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  if (email.isEmpty || password.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Email dan kata sandi tidak boleh kosong',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    authController.login(email, password);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002F91),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBackgroundColor:
                                const Color(0xFF002F91).withOpacity(0.6),
                          ),
                          child: authController.authState.value ==
                                  AuthState.Loading
                              ? const SizedBox(
                                  // Tampilkan loading indicator
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'belum punya akun? ',
                          style: TextStyle(
                            color: Color(0xB3FFFFFF),
                            fontFamily: 'poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.signup);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'buat akun',
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
