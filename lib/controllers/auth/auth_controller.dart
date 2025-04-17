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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Login Error',
          'Login failed. Please check your credentials.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });

      _updateAuthState(
          null); // Akan set ke Unauthenticated dan memastikan di halaman login
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
      }

      // Listener _onAuthStateChanged akan menangani navigasi setelah user dibuat
    } catch (e) {
      print("Registration failed for $email: ${e.toString()}");
      authState.value = AuthState.Error;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Registration Error',
          'Registration failed. ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });

      _updateAuthState(null);
    }
  }

  Future<void> logout() async {
    print("Attempting logout...");
    try {
      await _authService.signOut();
      print("Logout service call successful.");
    } catch (e) {
      print("Logout Error: ${e.toString()}");
      Get.snackbar(
        'Logout Error',
        'Could not log out. ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _updateAuthState(_authService.getCurrentUser());
    }
  }
}
