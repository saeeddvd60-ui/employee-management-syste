class AppConstants {
  // App Info
  static const String appName = 'سیستم مدیریت پرسنل';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Saeed';

  // Database
  static const String databaseName = 'employee_management.db';
  static const int databaseVersion = 1;

  // Shared Preferences Keys
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String userRoleKey = 'user_role';
  static const String isLoggedInKey = 'is_logged_in';
  static const String branchIdKey = 'branch_id';

  // Work Schedule
  static const String defaultWorkShiftStart = '08:00';
  static const String defaultWorkShiftEnd = '17:00';
  static const double defaultWorkHoursPerDay = 8.5;
  static const String defaultWorkingDays = '1,2,3,4,5'; // Sat to Wed

  // Leave Types
  static const String leaveTypeAnnual = 'annual';
  static const String leaveTypeSick = 'sick';
  static const String leaveTypeUnpaid = 'unpaid';
  static const String leaveTypeMaternity = 'maternity';
  static const String leaveTypeEstejazi = 'estejazi';

  // Attendance Status
  static const String attendanceStatusPresent = 'present';
  static const String attendanceStatusAbsent = 'absent';
  static const String attendanceStatusLate = 'late';
  static const String attendanceStatusEarlyLeave = 'early_leave';
  static const String attendanceStatusSickLeave = 'sick_leave';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleManager = 'manager';
  static const String roleEmployee = 'employee';

  // Pagination
  static const int pageSize = 20;

  // Time Constants
  static const int lateThresholdMinutes = 15;
}

class AppMessages {
  static const String errorOccurred = 'خطایی رخ داده است';
  static const String successMessage = 'عملیات موفق بود';
  static const String invalidUsername = 'نام کاربری نامعتبر است';
  static const String invalidPassword = 'رمز عبور نامعتبر است';
  static const String emptyFields = 'لطفاً تمام فیلدها را پر کنید';
  static const String loadingData = 'درحال بارگیری...';
  static const String noData = 'اطلاعاتی یافت نشد';
}

class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeoutDuration = Duration(seconds: 30);
}
