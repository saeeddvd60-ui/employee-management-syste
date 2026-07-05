class Holiday {
  int? id;
  DateTime holidayDate;
  String holidayName;
  String? holidayType; // national, friday, optional
  bool isApplicableToAll;
  int? branchId;
  DateTime? createdAt;

  Holiday({
    this.id,
    required this.holidayDate,
    required this.holidayName,
    this.holidayType,
    this.isApplicableToAll = true,
    this.branchId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'holiday_date': holidayDate.toIso8601String().split('T')[0],
      'holiday_name': holidayName,
      'holiday_type': holidayType,
      'is_applicable_to_all': isApplicableToAll ? 1 : 0,
      'branch_id': branchId,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory Holiday.fromMap(Map<String, dynamic> map) {
    return Holiday(
      id: map['id'],
      holidayDate: DateTime.parse(map['holiday_date']),
      holidayName: map['holiday_name'],
      holidayType: map['holiday_type'],
      isApplicableToAll: map['is_applicable_to_all'] == 1,
      branchId: map['branch_id'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
