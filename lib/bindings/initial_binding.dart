import 'package:get/get.dart';
import '../controllers/auth/auth_controller.dart';
import '../services/auth_service.dart';
import '../controllers/controller.dart'; // Import controller pengeluaran
import '../controllers/transactionController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Service Dependencies
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }

    // Controller Dependencies
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(Get.find<AuthService>()), permanent: true);
    }

    // Register TransactionController
    if (!Get.isRegistered<TransactionController>()) {
      Get.put(TransactionController(), permanent: true);
    }

    // Register other controllers (Pengeluaran, etc.)
    Get.lazyPut(() => ControllerPengeluaran(), fenix: true);
  }

  // Tambahkan metode untuk reset auth controllers jika diperlukan
  void resetAuthControllers() {
    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>();
    }
    
    // Ulangi registrasi
    Get.put(AuthController(Get.find<AuthService>()), permanent: true);
  }
}
