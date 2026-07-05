class Leave {
  int? id;
  int employeeId;
  String leaveType; // annual, sick, unpaid, maternity, estejazi
  DateTime startDate;
  DateTime endDate;
  int daysCount;
  String? reason;
  String status; // pending, approved, rejected
  int? approvedBy;
  DateTime? createdAt;

  Leave({
    this.id,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.reason,
    this.status = 'pending',
    this.approvedBy,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'leave_type': leaveType,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'days_count': daysCount,
      'reason': reason,
      'status': status,
      'approved_by': approvedBy,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory Leave.fromMap(Map<String, dynamic> map) {
    return Leave(
      id: map['id'],
      employeeId: map['employee_id'],
      leaveType: map['leave_type'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      daysCount: map['days_count'],
      reason: map['reason'],
      status: map['status'],
      approvedBy: map['approved_by'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
