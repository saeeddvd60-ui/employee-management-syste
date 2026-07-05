class Employee {
  int? id;
  String employeeCode;
  String firstName;
  String lastName;
  String nationalId;
  String? phone;
  String? email;
  String? gender; // male, female
  String? department;
  int branchId;
  DateTime hireDate;
  bool isActive;
  DateTime? createdAt;

  Employee({
    this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    this.phone,
    this.email,
    this.gender,
    this.department,
    required this.branchId,
    required this.hireDate,
    this.isActive = true,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_code': employeeCode,
      'first_name': firstName,
      'last_name': lastName,
      'national_id': nationalId,
      'phone': phone,
      'email': email,
      'gender': gender,
      'department': department,
      'branch_id': branchId,
      'hire_date': hireDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      employeeCode: map['employee_code'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      nationalId: map['national_id'],
      phone: map['phone'],
      email: map['email'],
      gender: map['gender'],
      department: map['department'],
      branchId: map['branch_id'],
      hireDate: DateTime.parse(map['hire_date']),
      isActive: map['is_active'] == 1,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
