import '../database/db_helper.dart';
import '../models/work_log.dart';
import '../models/attendance.dart';
import '../models/contract.dart';

class WorkLogService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Generate work log for a day
  Future<bool> generateWorkLog(
    int employeeId,
    DateTime logDate,
    double workedHours,
    String workType,
  ) async {
    try {
      final workLog = WorkLog(
        employeeId: employeeId,
        logDate: logDate,
        workedHours: workedHours,
        workType: workType,
      );

      await _dbHelper.insertWorkLog(workLog);
      return true;
    } catch (e) {
      print('Error generating work log: $e');
      return false;
    }
  }

  // Get work logs by date range
  Future<List<WorkLog>> getWorkLogsByDateRange(
    int employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _dbHelper.getWorkLogsByEmployeeAndDateRange(
        employeeId,
        startDate,
        endDate,
      );
    } catch (e) {
      print('Error getting work logs: $e');
      return [];
    }
  }

  // Calculate overtime
  Future<double> calculateOvertime(
    int employeeId,
    DateTime logDate,
    Attendance attendance,
    Contract contract,
  ) async {
    try {
      if (attendance.checkInTime == null || attendance.checkOutTime == null) {
        return 0;
      }

      final checkIn = _parseTime(attendance.checkInTime!);
      final checkOut = _parseTime(attendance.checkOutTime!);

      if (checkIn == null || checkOut == null) return 0;

      final workedMinutes = checkOut.difference(checkIn).inMinutes;
      final workedHours = workedMinutes / 60.0;
      final expectedHours = contract.workHoursPerDay;

      if (workedHours > expectedHours) {
        return workedHours - expectedHours;
      }
      return 0;
    } catch (e) {
      print('Error calculating overtime: $e');
      return 0;
    }
  }

  // Add overtime hours to work log
  Future<bool> addOvertimeHours(
    int employeeId,
    DateTime logDate,
    double overtimeHours,
  ) async {
    try {
      final workLogs = await getWorkLogsByDateRange(logDate, logDate, logDate);
      if (workLogs.isNotEmpty) {
        final workLog = workLogs.first;
        workLog.overtimeHours = overtimeHours;
        await _dbHelper.updateWorkLog(workLog);
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding overtime: $e');
      return false;
    }
  }

  // Add deduction hours
  Future<bool> addDeductionHours(
    int employeeId,
    DateTime logDate,
    double deductionHours,
    String reason,
  ) async {
    try {
      final workLogs = await getWorkLogsByDateRange(logDate, logDate, logDate);
      if (workLogs.isNotEmpty) {
        final workLog = workLogs.first;
        workLog.deductionHours = deductionHours;
        workLog.notes = reason;
        await _dbHelper.updateWorkLog(workLog);
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding deduction: $e');
      return false;
    }
  }

  // Get monthly summary
  Future<Map<String, dynamic>> getMonthlySummary(
    int employeeId,
    int year,
    int month,
  ) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final workLogs = await getWorkLogsByDateRange(
        employeeId,
        startDate,
        endDate,
      );

      double totalWorkedHours = 0;
      double totalOvertimeHours = 0;
      double totalDeductionHours = 0;

      for (var log in workLogs) {
        totalWorkedHours += log.workedHours;
        totalOvertimeHours += log.overtimeHours;
        totalDeductionHours += log.deductionHours;
      }

      return {
        'total_worked_hours': totalWorkedHours,
        'total_overtime_hours': totalOvertimeHours,
        'total_deduction_hours': totalDeductionHours,
        'net_hours': totalWorkedHours + totalOvertimeHours - totalDeductionHours,
      };
    } catch (e) {
      print('Error getting monthly summary: $e');
      return {};
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
