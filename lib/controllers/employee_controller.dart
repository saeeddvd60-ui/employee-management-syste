import 'package:get/get.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeController extends GetxController {
  final EmployeeService _employeeService = EmployeeService();

  final RxList<Employee> employees = RxList<Employee>();
  final RxBool isLoading = RxBool(false);
  final RxString searchQuery = RxString('');
  final RxList<Employee> filteredEmployees = RxList<Employee>();

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
    ever(searchQuery, (_) => _filterEmployees());
  }

  Future<void> loadEmployees() async {
    isLoading.value = true;
    try {
      final result = await _employeeService.getAllEmployees();
      employees.assignAll(result);
      filteredEmployees.assignAll(result);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگیری پرسنل: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addEmployee(Employee employee) async {
    isLoading.value = true;
    try {
      bool result = await _employeeService.addEmployee(employee, 
        // Default contract
        await _createDefaultContract(employee.id ?? 0)
      );
      if (result) {
        await loadEmployees();
        Get.snackbar('موفق', 'پرسنل با موفقیت اضافه شد');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در اضافه کردن پرسنل: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void searchEmployees(String query) {
    searchQuery.value = query;
  }

  void _filterEmployees() {
    if (searchQuery.value.isEmpty) {
      filteredEmployees.assignAll(employees);
    } else {
      final query = searchQuery.value.toLowerCase();
      final filtered = employees
          .where((emp) =>
              emp.fullName.toLowerCase().contains(query) ||
              emp.employeeCode.toLowerCase().contains(query) ||
              emp.nationalId.contains(query))
          .toList();
      filteredEmployees.assignAll(filtered);
    }
  }

  Future<dynamic> _createDefaultContract(int employeeId) async {
    // Will be implemented
    return null;
  }
}
