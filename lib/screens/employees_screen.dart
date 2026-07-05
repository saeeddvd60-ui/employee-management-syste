import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import '../models/employee.dart';
import '../utils/colors.dart';
import '../utils/validators.dart';
import '../widgets/custom_widgets.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late EmployeeController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(EmployeeController());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت پرسنل'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _controller.searchEmployees(value),
              decoration: InputDecoration(
                hintText: 'جستجوی پرسنل...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),
          // Employee List
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.filteredEmployees.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'هیچ پرسنلی پیدا نشد',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _controller.filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = _controller.filteredEmployees[index];
                  return EmployeeCard(
                    employeeName: employee.fullName,
                    employeeCode: employee.employeeCode,
                    department: employee.department ?? 'مشخص نشده',
                    branch: 'شعبه ${employee.branchId}',
                    onTap: () => _showEmployeeDetails(employee),
                    onEdit: () => _editEmployee(employee),
                    onDelete: () => _deleteEmployee(employee),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEmployeeDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEmployeeDialog() {
    Get.defaultDialog(
      title: 'افزودن پرسنل جدید',
      content: const SingleChildScrollView(
        child: Column(
          children: [
            Text(این بخش در حال توسعه است),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('بستن'),
      ),
    );
  }

  void _showEmployeeDetails(Employee employee) {
    Get.snackbar(
      'اطلاعات پرسنل',
      '${employee.fullName}\nکد: ${employee.employeeCode}\nشماره ملی: ${employee.nationalId}',
      duration: const Duration(seconds: 3),
    );
  }

  void _editEmployee(Employee employee) {
    Get.snackbar('ویرایش', 'ویرایش پرسنل در حال توسعه');
  }

  void _deleteEmployee(Employee employee) {
    Get.defaultDialog(
      title: 'تایید حذف',
      content: Text('آیا مطمئن هستید می خواهید ${employee.fullName} را حذف کنید?'),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
        child: const Text('لغو'),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.snackbar('موفق', 'پرسنل حذف شد');
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
        child: const Text('بله'),
      ),
    );
  }
}
