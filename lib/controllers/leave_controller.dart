import 'package:get/get.dart';
import '../models/leave.dart';
import '../services/leave_service.dart';

class LeaveController extends GetxController {
  final LeaveService _leaveService = LeaveService();

  final RxList<Leave> leaves = RxList<Leave>();
  final RxList<Leave> pendingLeaves = RxList<Leave>();
  final RxBool isLoading = RxBool(false);

  Future<void> loadLeavesByEmployee(int employeeId) async {
    isLoading.value = true;
    try {
      final result = await _leaveService.getLeavesByEmployee(employeeId);
      leaves.assignAll(result);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگیری مرخصی: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPendingLeaves() async {
    isLoading.value = true;
    try {
      final result = await _leaveService.getPendingLeaves();
      pendingLeaves.assignAll(result);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگیری مرخصی های در انتظار: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> requestLeave(Leave leave) async {
    isLoading.value = true;
    try {
      bool result = await _leaveService.requestLeave(leave);
      if (result) {
        Get.snackbar('موفق', 'درخواست مرخصی ثبت شد');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ثبت درخواست: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> approveLeave(int leaveId, int approvedBy) async {
    try {
      bool result = await _leaveService.approveLeave(leaveId, approvedBy);
      if (result) {
        await loadPendingLeaves();
        Get.snackbar('موفق', 'مرخصی تایید شد');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در تایید مرخصی: $e');
      return false;
    }
  }

  Future<bool> rejectLeave(int leaveId) async {
    try {
      bool result = await _leaveService.rejectLeave(leaveId);
      if (result) {
        await loadPendingLeaves();
        Get.snackbar('موفق', 'مرخصی رد شد');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در رد کردن مرخصی: $e');
      return false;
    }
  }

  Future<int> getRemainingAnnualLeaves(int employeeId, int year) async {
    try {
      return await _leaveService.getRemainingAnnualLeaves(employeeId, year);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در محاسبه مرخصی: $e');
      return 0;
    }
  }
}
