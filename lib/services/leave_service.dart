import '../database/db_helper.dart';
import '../models/leave.dart';

class LeaveService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Request new leave
  Future<bool> requestLeave(Leave leave) async {
    try {
      await _dbHelper.insertLeave(leave);
      return true;
    } catch (e) {
      print('Error requesting leave: $e');
      return false;
    }
  }

  // Get leaves by employee
  Future<List<Leave>> getLeavesByEmployee(int employeeId) async {
    try {
      return await _dbHelper.getLeavesByEmployee(employeeId);
    } catch (e) {
      print('Error getting leaves: $e');
      return [];
    }
  }

  // Get pending leaves
  Future<List<Leave>> getPendingLeaves() async {
    try {
      return await _dbHelper.getPendingLeaves();
    } catch (e) {
      print('Error getting pending leaves: $e');
      return [];
    }
  }

  // Approve leave
  Future<bool> approveLeave(int leaveId, int approvedBy) async {
    try {
      final leaves = await _dbHelper.getLeavesByEmployee(0); // Get all leaves
      final leave = leaves.firstWhere((l) => l.id == leaveId);
      leave.status = 'approved';
      leave.approvedBy = approvedBy;
      await _dbHelper.updateLeave(leave);
      return true;
    } catch (e) {
      print('Error approving leave: $e');
      return false;
    }
  }

  // Reject leave
  Future<bool> rejectLeave(int leaveId) async {
    try {
      final leaves = await _dbHelper.getLeavesByEmployee(0);
      final leave = leaves.firstWhere((l) => l.id == leaveId);
      leave.status = 'rejected';
      await _dbHelper.updateLeave(leave);
      return true;
    } catch (e) {
      print('Error rejecting leave: $e');
      return false;
    }
  }

  // Calculate remaining annual leaves
  Future<int> getRemainingAnnualLeaves(int employeeId, int year) async {
    try {
      const int totalAnnualLeaves = 20;
      final leaves = await getLeavesByEmployee(employeeId);
      
      int usedLeaves = 0;
      for (var leave in leaves) {
        if (leave.leaveType == 'annual' &&
            leave.status == 'approved' &&
            leave.startDate.year == year) {
          usedLeaves += leave.daysCount;
        }
      }

      return totalAnnualLeaves - usedLeaves;
    } catch (e) {
      print('Error calculating remaining leaves: $e');
      return 0;
    }
  }

  // Check if employee is on leave on a specific date
  Future<bool> isEmployeeOnLeave(int employeeId, DateTime date) async {
    try {
      final leaves = await getLeavesByEmployee(employeeId);
      return leaves.any((leave) =>
          leave.status == 'approved' &&
          date.isAfter(leave.startDate) &&
          date.isBefore(leave.endDate.add(Duration(days: 1))));
    } catch (e) {
      print('Error checking if on leave: $e');
      return false;
    }
  }
}
