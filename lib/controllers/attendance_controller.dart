import 'package:get/get.dart';
import '../models/attendance.dart';
import '../services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = AttendanceService();

  final RxList<Attendance> attendances = RxList<Attendance>();
  final RxInt presentCount = RxInt(0);
  final RxInt absentCount = RxInt(0);
  final RxBool isLoading = RxBool(false);
  final Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    loadTodayStats();
  }

  Future<void> loadTodayStats() async {
    isLoading.value = true;
    try {
      final present = await _attendanceService.getTodayPresentCount();
      final absent = await _attendanceService.getTodayAbsentCount();
      presentCount.value = present;
      absentCount.value = absent;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگیری آمار: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkIn(int employeeId) async {
    try {
      bool result = await _attendanceService.checkIn(employeeId);
      if (result) {
        await loadTodayStats();
        Get.snackbar('موفق', 'ورود ثبت شد');
        return true;
      } else {
        Get.snackbar('هشدار', 'قبلاً ورود ثبت شده است');
        return false;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ثبت ورود: $e');
      return false;
    }
  }

  Future<bool> checkOut(int employeeId) async {
    try {
      bool result = await _attendanceService.checkOut(employeeId);
      if (result) {
        await loadTodayStats();
        Get.snackbar('موفق', 'خروج ثبت شد');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ثبت خروج: $e');
      return false;
    }
  }

  Future<bool> markAbsent(int employeeId, DateTime date) async {
    try {
      bool result = await _attendanceService.markAbsent(employeeId, date);
      if (result) {
        await loadTodayStats();
        Get.snackbar('موفق', 'غیبت ثبت شد');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ثبت غیبت: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getMonthlyStats(int employeeId, int year, int month) async {
    try {
      return await _attendanceService.getMonthlyStatistics(employeeId, year, month);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در محاسبه آمار: $e');
      return {};
    }
  }
}
