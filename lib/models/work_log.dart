class WorkLog {
  int? id;
  int employeeId;
  DateTime logDate;
  double workedHours;
  double overtimeHours;
  double deductionHours; // کسر کار
  String workType; // normal, holiday, sick_leave, leave
  String? notes;
  DateTime? createdAt;

  WorkLog({
    this.id,
    required this.employeeId,
    required this.logDate,
    required this.workedHours,
    this.overtimeHours = 0,
    this.deductionHours = 0,
    required this.workType,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'log_date': logDate.toIso8601String().split('T')[0],
      'worked_hours': workedHours,
      'overtime_hours': overtimeHours,
      'deduction_hours': deductionHours,
      'work_type': workType,
      'notes': notes,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory WorkLog.fromMap(Map<String, dynamic> map) {
    return WorkLog(
      id: map['id'],
      employeeId: map['employee_id'],
      logDate: DateTime.parse(map['log_date']),
      workedHours: map['worked_hours'],
      overtimeHours: map['overtime_hours'] ?? 0,
      deductionHours: map['deduction_hours'] ?? 0,
      workType: map['work_type'],
      notes: map['notes'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
