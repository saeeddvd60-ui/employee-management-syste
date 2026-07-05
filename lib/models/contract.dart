class Contract {
  int? id;
  int employeeId;
  String workShiftStart; // "08:00"
  String workShiftEnd; // "17:00"
  String workingDays; // "1,2,3,4,5" (Saturday to Wednesday)
  double workHoursPerDay; // 8.5
  String? contractType; // full-time, part-time
  DateTime startDate;
  DateTime? endDate;
  bool isActive;

  Contract({
    this.id,
    required this.employeeId,
    required this.workShiftStart,
    required this.workShiftEnd,
    required this.workingDays,
    required this.workHoursPerDay,
    this.contractType = 'full-time',
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  List<int> getWorkingDaysList() {
    return workingDays.split(',').map((e) => int.parse(e.trim())).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'work_shift_start': workShiftStart,
      'work_shift_end': workShiftEnd,
      'working_days': workingDays,
      'work_hours_per_day': workHoursPerDay,
      'contract_type': contractType,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      id: map['id'],
      employeeId: map['employee_id'],
      workShiftStart: map['work_shift_start'],
      workShiftEnd: map['work_shift_end'],
      workingDays: map['working_days'],
      workHoursPerDay: map['work_hours_per_day'],
      contractType: map['contract_type'],
      startDate: DateTime.parse(map['start_date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      isActive: map['is_active'] == 1,
    );
  }
}
