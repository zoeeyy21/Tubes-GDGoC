import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewallet/services/auth_service.dart';
import 'package:ewallet/models/user.dart';
import 'package:ewallet/models/enum.dart';
import 'package:ewallet/routes.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  AuthController(this._authService);

  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<AuthState> authState = AuthState.Unauthenticated.obs;
  StreamSubscription? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    print("AuthController onInit: Initializing...");

    // Periksa status auth saat ini sebelum mendengarkan perubahan
    User? initialUser = _authService.getCurrentUser();
    if (initialUser != null) {
      _updateAuthState(initialUser);
    } else {
      // Pastikan status awal adalah Unauthenticated jika tidak ada user
      authState.value = AuthState.Unauthenticated;
    }

    // Setelah menetapkan state awal, baru mulai mendengarkan perubahan
    _authSubscription = _authService.authStateChanges
        .listen(_onAuthStateChanged, onError: (error) {
      print("Auth Stream Error: $error");
      _updateAuthState(null);
    });
  }

  @override
  void onClose() {
    print("AuthController onClose: Cancelling auth subscription.");
    _authSubscription?.cancel();
    super.onClose();
  }

  void _updateAuthState(User? user) {
    currentUser.value = user;
    if (user != null) {
      // Jika ada user -> Authenticated
      if (authState.value != AuthState.Authenticated) {
        print("Updating state to Authenticated for user: ${user.uid}");
        authState.value = AuthState.Authenticated;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("Navigating to Home Route: ${AppRoutes.home}");
          Get.offAllNamed(AppRoutes.home);
        });
      }
    } else {
      // Jika tidak ada user -> Unauthenticated
      if (authState.value != AuthState.Unauthenticated) {
        print("Updating state to Unauthenticated");
        authState.value = AuthState.Unauthenticated;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final currentRoute = Get.currentRoute;
          print("Current route: $currentRoute");
          if (currentRoute != AppRoutes.login &&
              currentRoute != AppRoutes.signup) {
            print("Navigating to Login Route: ${AppRoutes.login}");
            Get.offAllNamed(AppRoutes.login);
          } else {
            print("Already on auth route, no navigation needed.");
          }
        });
      }
    }
  }

  // Listener yang dipanggil setiap kali state auth Firebase berubah
  void _onAuthStateChanged(User? user) {
    print("_onAuthStateChanged triggered. User: ${user?.uid ?? 'null'}");
    _updateAuthState(user);
  }

  Future<void> login(String email, String password) async {
    if (authState.value == AuthState.Loading) return;

    print("Attempting login for: $email");
    authState.value = AuthState.Loading;

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      print("Login service call successful for: $email");
      print(
          "Current user after login: ${_authService.getCurrentUser()?.uid ?? 'null'}");

      User? user = _authService.getCurrentUser();
      if (user != null) {
        print("Manually triggering auth state update after confirmed login");
        _onAuthStateChanged(user);
      }
    } catch (e) {
      print("Login failed for $email: ${e.toString()}");
      authState.value = AuthState.Error;

      // Menangani berbagai jenis error Firebase Auth
      String errorMessage = 'Login gagal. Silakan coba lagi.';

      if (e.toString().contains('user-not-found')) {
        errorMessage =
            'Email tidak terdaftar. Silakan buat akun terlebih dahulu.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Password salah. Coba lagi.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Format email tidak valid.';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'Akun ini telah dinonaktifkan. Hubungi admin.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Koneksi internet terputus. Periksa koneksi Anda.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Terlalu banyak percobaan login. Coba lagi nanti.';
      }

      // Menampilkan error dengan Snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Login Gagal',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 10,
          duration: Duration(seconds: 4),
        );
      });

      // Reset state ke Unauthenticated
      authState.value = AuthState.Unauthenticated;
    }
  }

  Future<void> register(String email, String password, String username) async {
    if (authState.value == AuthState.Loading) return;

    print("Attempting registration for: $email with username: $username");
    authState.value = AuthState.Loading;

    try {
      // Langkah 1: Buat akun email/password
      await _authService.signUpWithEmailAndPassword(email, password);
      print("Registration service call successful for: $email");

      // Langkah 2: Update profil dengan username
      User? user = _authService.getCurrentUser();
      if (user != null) {
        await _authService.updateUserProfile(username);
        print("Username updated successfully for user: ${user.uid}");

        // Memastikan state pengguna diperbarui dengan data terbaru
        _onAuthStateChanged(_authService.getCurrentUser());
      } else {
        print("Warning: User is null after registration");
        authState.value = AuthState.Unauthenticated;
      }
    } catch (e) {
      print("Registration failed for $email: ${e.toString()}");
      authState.value = AuthState.Unauthenticated;

      String errorMessage = 'Pendaftaran gagal. Silakan coba lagi.';

      // Menerjemahkan pesan error dari Firebase
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Email sudah digunakan. Silakan gunakan email lain.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Format email tidak valid.';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Koneksi internet terputus. Periksa koneksi Anda.';
      }

      // Tampilkan error dengan GetX snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Pendaftaran Gagal',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 10,
          duration: Duration(seconds: 4),
        );
      });
    }
  }

  Future<void> logout() async {
    print("Attempting logout...");
    try {
      // Set state dulu ke Unauthenticated sebelum menjalankan aksi logout
      authState.value = AuthState.Unauthenticated;

      // Kosongkan user data sebelum signout
      currentUser.value = null;

      // Panggil signOut di service
      await _authService.signOut();
      print("Logout service call successful.");

      // Tambahkan delay kecil untuk memastikan state terupdate
      await Future.delayed(Duration(milliseconds: 100));

      // Navigasi ke login dengan post-frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.login);
      });
    } catch (e) {
      print("Logout Error: ${e.toString()}");
      // Pastikan UI tetap responsif bahkan jika error
      authState.value = AuthState.Error;

      // Tampilkan error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Logout Error',
          'Could not log out. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });

      // Cek user status untuk recovery
      User? currentUserCheck = _authService.getCurrentUser();
      if (currentUserCheck != null) {
        authState.value = AuthState.Authenticated;
        currentUser.value = currentUserCheck;
      } else {
        authState.value = AuthState.Unauthenticated;
      }
    }
  }
}
