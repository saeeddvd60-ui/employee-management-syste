import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  
  final RxMap<String, dynamic> currentUser = RxMap<String, dynamic>();
  final RxBool isLoggedIn = RxBool(false);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      if (userId != null) {
        currentUser.value = {
          'id': userId,
          'username': prefs.getString('username'),
          'full_name': prefs.getString('full_name'),
          'role': prefs.getString('role'),
          'branch_id': prefs.getInt('branch_id'),
        };
        isLoggedIn.value = true;
      }
    } catch (e) {
      print('خطا در بررسی وضعیت ورود: $e');
    }
  }

  Future<bool> login(String username, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(username, password);
      if (user != null) {
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user['id']);
        await prefs.setString('username', user['username']);
        await prefs.setString('full_name', user['full_name']);
        await prefs.setString('role', user['role']);
        if (user['branch_id'] != null) {
          await prefs.setInt('branch_id', user['branch_id']);
        }

        currentUser.value = user;
        isLoggedIn.value = true;
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ورود: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      currentUser.clear();
      isLoggedIn.value = false;
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Get.snackbar('خطا', 'خطا در خروج: $e');
    }
  }
}
