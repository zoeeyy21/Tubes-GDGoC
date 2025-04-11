import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes.dart';

class SignUp extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                        Get.offNamed(AppRoutes.home);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002F91),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Buat Akun',
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
