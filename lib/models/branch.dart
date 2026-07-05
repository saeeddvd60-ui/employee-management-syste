class Branch {
  int? id;
  String name;
  String? location;
  String? phone;
  int? managerId;
  DateTime? createdAt;

  Branch({
    this.id,
    required this.name,
    this.location,
    this.phone,
    this.managerId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      'manager_id': managerId,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      phone: map['phone'],
      managerId: map['manager_id'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
