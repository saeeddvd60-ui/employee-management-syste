import '../database/db_helper.dart';
import '../models/attendance.dart';
import '../models/contract.dart';
import '../models/employee.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class AttendanceService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Check-in employee
  Future<bool> checkIn(int employeeId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Check if already checked in today
      final existingAttendance =
          await _dbHelper.getAttendanceByEmployeeAndDate(employeeId, today);
      if (existingAttendance.isNotEmpty) {
        return false; // Already checked in
      }

      final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final attendance = Attendance(
        employeeId: employeeId,
        attendanceDate: today,
        checkInTime: timeString,
        status: AppConstants.attendanceStatusPresent,
      );

      await _dbHelper.insertAttendance(attendance);
      return true;
    } catch (e) {
      print('Error checking in: $e');
      return false;
    }
  }

  // Check-out employee
  Future<bool> checkOut(int employeeId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final attendanceList =
          await _dbHelper.getAttendanceByEmployeeAndDate(employeeId, today);

      if (attendanceList.isEmpty) {
        return false; // No check-in found
      }

      final attendance = attendanceList.first;
      attendance.checkOutTime = timeString;
      await _dbHelper.updateAttendance(attendance);
      return true;
    } catch (e) {
      print('Error checking out: $e');
      return false;
    }
  }

  // Mark as absent
  Future<bool> markAbsent(int employeeId, DateTime date) async {
    try {
      final attendance = Attendance(
        employeeId: employeeId,
        attendanceDate: date,
        status: AppConstants.attendanceStatusAbsent,
      );

      await _dbHelper.insertAttendance(attendance);
      return true;
    } catch (e) {
      print('Error marking absent: $e');
      return false;
    }
  }

  // Get attendance by date range
  Future<List<Attendance>> getAttendanceByDateRange(
    int employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _dbHelper.getAttendanceByEmployeeAndDateRange(
        employeeId,
        startDate,
        endDate,
      );
    } catch (e) {
      print('Error getting attendance: $e');
      return [];
    }
  }

  // Get today's attendance
  Future<Attendance?> getTodayAttendance(int employeeId) async {
    try {
      final today = DateTime.now();
      final attendanceList =
          await _dbHelper.getAttendanceByEmployeeAndDate(employeeId, today);
      return attendanceList.isNotEmpty ? attendanceList.first : null;
    } catch (e) {
      print('Error getting today attendance: $e');
      return null;
    }
  }

  // Calculate attendance statistics for a month
  Future<Map<String, dynamic>> getMonthlyStatistics(
    int employeeId,
    int year,
    int month,
  ) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final attendances = await getAttendanceByDateRange(
        employeeId,
        startDate,
        endDate,
      );

      int presentDays = 0;
      int absentDays = 0;
      int lateDays = 0;
      int earlyLeaveDays = 0;
      double totalWorkedHours = 0;

      final contract = await _dbHelper.getContractByEmployeeId(employeeId);
      if (contract == null) return {};

      for (var attendance in attendances) {
        if (attendance.status == AppConstants.attendanceStatusPresent) {
          presentDays++;
          if (attendance.checkInTime != null && attendance.checkOutTime != null) {
            // Calculate worked hours
            final checkInTime = _parseTime(attendance.checkInTime!);
            final checkOutTime = _parseTime(attendance.checkOutTime!);
            if (checkInTime != null && checkOutTime != null) {
              final diff = checkOutTime.difference(checkInTime);
              totalWorkedHours += diff.inMinutes / 60.0;
            }
          }
        } else if (attendance.status == AppConstants.attendanceStatusAbsent) {
          absentDays++;
        } else if (attendance.status == AppConstants.attendanceStatusLate) {
          lateDays++;
        } else if (attendance.status == AppConstants.attendanceStatusEarlyLeave) {
          earlyLeaveDays++;
        }
      }

      return {
        'present_days': presentDays,
        'absent_days': absentDays,
        'late_days': lateDays,
        'early_leave_days': earlyLeaveDays,
        'total_worked_hours': totalWorkedHours.toStringAsFixed(2),
        'total_days': attendances.length,
      };
    } catch (e) {
      print('Error calculating statistics: $e');
      return {};
    }
  }

  // Get today present count
  Future<int> getTodayPresentCount() async {
    try {
      final today = DateTime.now();
      return await _dbHelper.getTodayPresentCount(today);
    } catch (e) {
      print('Error getting today present count: $e');
      return 0;
    }
  }

  // Get today absent count
  Future<int> getTodayAbsentCount() async {
    try {
      final today = DateTime.now();
      return await _dbHelper.getTodayAbsentCount(today);
    } catch (e) {
      print('Error getting today absent count: $e');
      return 0;
    }
  }

  // Helper function to parse time string
  DateTime? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
      return null;
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }
}
