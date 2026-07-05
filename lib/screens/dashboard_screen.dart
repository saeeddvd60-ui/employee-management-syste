import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/employee_service.dart';
import '../services/attendance_service.dart';
import '../utils/colors.dart';
import 'employees_screen.dart';
import 'attendance_screen.dart';
import 'leaves_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EmployeeService _employeeService = EmployeeService();
  final AttendanceService _attendanceService = AttendanceService();
  
  late Map<String, dynamic> _currentUser;
  int _totalEmployees = 0;
  int _presentToday = 0;
  int _absentToday = 0;

  @override
  void initState() {
    super.initState();
    _currentUser = Get.arguments ?? {};
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final employees = await _employeeService.getTotalEmployeesCount();
      final present = await _attendanceService.getTodayPresentCount();
      final absent = await _attendanceService.getTodayAbsentCount();

      setState(() {
        _totalEmployees = employees;
        _presentToday = present;
        _absentToday = absent;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سیستم مدیریت پرسنل'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'خوش آمدید: ${_currentUser['full_name'] ?? 'کاربر'}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'کل پرسنل',
                    _totalEmployees.toString(),
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'حاضر امروز',
                    _presentToday.toString(),
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'غایب امروز',
                    _absentToday.toString(),
                    Icons.cancel,
                    AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'در حال کار',
                    (_totalEmployees - _absentToday).toString(),
                    Icons.work,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            const Text(
              'دسترسی سریع',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'مدیریت پرسنل',
              Icons.people_alt,
              AppColors.primary,
              () {
                Get.to(() => const EmployeesScreen());
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'ثبت حضور و غیبت',
              Icons.assignment,
              AppColors.secondary,
              () {
                Get.to(() => const AttendanceScreen());
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'مدیریت مرخصی',
              Icons.calendar_month,
              AppColors.accent,
              () {
                Get.to(() => const LeavesScreen());
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'گزارش‌ها',
              Icons.assessment,
              AppColors.info,
              () {
                Get.snackbar('اطلاعات', 'بخش گزارش‌ها در حال توسعه است');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
