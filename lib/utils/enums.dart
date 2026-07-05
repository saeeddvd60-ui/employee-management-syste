enum UserRole {
  admin,
  manager,
  employee,
}

enum LeaveType {
  annual,
  sick,
  unpaid,
  maternity,
  estejazi,
}

enum AttendanceStatus {
  present,
  absent,
  late,
  earlyLeave,
  sickLeave,
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

enum WorkType {
  normal,
  holiday,
  sickLeave,
  leave,
}

enum ContractType {
  fullTime,
  partTime,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'مدیر';
      case UserRole.manager:
        return 'سرپرست';
      case UserRole.employee:
        return 'پرسنل';
    }
  }
}

extension LeaveTypeExtension on LeaveType {
  String get displayName {
    switch (this) {
      case LeaveType.annual:
        return 'مرخصی سالانه';
      case LeaveType.sick:
        return 'مرخصی استعلاجی';
      case LeaveType.unpaid:
        return 'مرخصی بی‌حقوق';
      case LeaveType.maternity:
        return 'مرخصی زایمان';
      case LeaveType.estejazi:
        return 'مرخصی استعلاجی';
    }
  }
}

extension AttendanceStatusExtension on AttendanceStatus {
  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'حاضر';
      case AttendanceStatus.absent:
        return 'غایب';
      case AttendanceStatus.late:
        return 'دیر رفتار';
      case AttendanceStatus.earlyLeave:
        return 'خروج زودهنگام';
      case AttendanceStatus.sickLeave:
        return 'مرخصی استعلاجی';
    }
  }
}
