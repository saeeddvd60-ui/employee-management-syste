import '../database/db_helper.dart';
import '../models/employee.dart';
import '../models/contract.dart';

class EmployeeService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Add new employee with contract
  Future<bool> addEmployee(Employee employee, Contract contract) async {
    try {
      final db = await _dbHelper.database;
      await db.transaction((txn) async {
        // Insert employee
        final employeeId = await txn.insert(
          DatabaseHelper.tableEmployees,
          employee.toMap(),
        );

        // Insert contract
        contract.employeeId = employeeId;
        await txn.insert(
          DatabaseHelper.tableContracts,
          contract.toMap(),
        );
      });
      return true;
    } catch (e) {
      print('Error adding employee: $e');
      return false;
    }
  }

  // Get all employees
  Future<List<Employee>> getAllEmployees() async {
    return await _dbHelper.getAllEmployees();
  }

  // Get employees by branch
  Future<List<Employee>> getEmployeesByBranch(int branchId) async {
    return await _dbHelper.getEmployeesByBranch(branchId);
  }

  // Get employee by id with contract
  Future<Map<String, dynamic>?> getEmployeeWithContract(int employeeId) async {
    try {
      final employee = await _dbHelper.getEmployeeById(employeeId);
      if (employee != null) {
        final contract = await _dbHelper.getContractByEmployeeId(employeeId);
        return {
          'employee': employee,
          'contract': contract,
        };
      }
      return null;
    } catch (e) {
      print('Error getting employee with contract: $e');
      return null;
    }
  }

  // Update employee
  Future<bool> updateEmployee(Employee employee) async {
    try {
      await _dbHelper.updateEmployee(employee);
      return true;
    } catch (e) {
      print('Error updating employee: $e');
      return false;
    }
  }

  // Delete employee (soft delete)
  Future<bool> deleteEmployee(int employeeId) async {
    try {
      await _dbHelper.deleteEmployee(employeeId);
      return true;
    } catch (e) {
      print('Error deleting employee: $e');
      return false;
    }
  }

  // Search employees
  Future<List<Employee>> searchEmployees(String query) async {
    try {
      final allEmployees = await getAllEmployees();
      return allEmployees
          .where((emp) =>
              emp.fullName.toLowerCase().contains(query.toLowerCase()) ||
              emp.employeeCode.toLowerCase().contains(query.toLowerCase()) ||
              emp.nationalId.contains(query))
          .toList();
    } catch (e) {
      print('Error searching employees: $e');
      return [];
    }
  }

  // Get total employees count
  Future<int> getTotalEmployeesCount() async {
    try {
      final employees = await getAllEmployees();
      return employees.length;
    } catch (e) {
      print('Error getting employees count: $e');
      return 0;
    }
  }
}
