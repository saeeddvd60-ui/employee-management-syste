class Attendance {
  int? id;
  int employeeId;
  DateTime attendanceDate;
  String? checkInTime; // "08:15"
  String? checkOutTime; // "17:30"
  String status; // present, absent, late, early_leave, sick_leave
  String? notes;
  DateTime? createdAt;

  Attendance({
    this.id,
    required this.employeeId,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'attendance_date': attendanceDate.toIso8601String().split('T')[0],
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'notes': notes,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      employeeId: map['employee_id'],
      attendanceDate: DateTime.parse(map['attendance_date']),
      checkInTime: map['check_in_time'],
      checkOutTime: map['check_out_time'],
      status: map['status'],
      notes: map['notes'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
