import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee.dart';
import '../models/branch.dart';
import '../models/contract.dart';
import '../models/attendance.dart';
import '../models/leave.dart';
import '../models/work_log.dart';
import '../models/holiday.dart';

class DatabaseHelper {
  static const String _databaseName = 'employee_management.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableUsers = 'users';
  static const String tableBranches = 'branches';
  static const String tableEmployees = 'employees';
  static const String tableContracts = 'contracts';
  static const String tableAttendance = 'attendance';
  static const String tableLeaves = 'leaves';
  static const String tableWorkLogs = 'work_logs';
  static const String tableHolidays = 'holidays';
  static const String tableAuditLog = 'audit_log';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create Branches table
    await db.execute('''
      CREATE TABLE $tableBranches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT,
        phone TEXT,
        manager_id INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create Employees table
    await db.execute('''
      CREATE TABLE $tableEmployees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_code TEXT UNIQUE NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        national_id TEXT UNIQUE NOT NULL,
        phone TEXT,
        email TEXT,
        gender TEXT,
        department TEXT,
        branch_id INTEGER NOT NULL,
        hire_date TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (branch_id) REFERENCES $tableBranches(id)
      )
    ''');

    // Create Contracts table
    await db.execute('''
      CREATE TABLE $tableContracts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER NOT NULL,
        work_shift_start TEXT NOT NULL,
        work_shift_end TEXT NOT NULL,
        working_days TEXT NOT NULL,
        work_hours_per_day REAL NOT NULL,
        contract_type TEXT,
        start_date TEXT NOT NULL,
        end_date TEXT,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (employee_id) REFERENCES $tableEmployees(id)
      )
    ''');

    // Create Attendance table
    await db.execute('''
      CREATE TABLE $tableAttendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER NOT NULL,
        attendance_date TEXT NOT NULL,
        check_in_time TEXT,
        check_out_time TEXT,
        status TEXT NOT NULL,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (employee_id) REFERENCES $tableEmployees(id)
      )
    ''');

    // Create Leaves table
    await db.execute('''
      CREATE TABLE $tableLeaves (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER NOT NULL,
        leave_type TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        days_count INTEGER NOT NULL,
        reason TEXT,
        status TEXT DEFAULT 'pending',
        approved_by INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (employee_id) REFERENCES $tableEmployees(id)
      )
    ''');

    // Create WorkLogs table
    await db.execute('''
      CREATE TABLE $tableWorkLogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER NOT NULL,
        log_date TEXT NOT NULL,
        worked_hours REAL NOT NULL,
        overtime_hours REAL DEFAULT 0,
        deduction_hours REAL DEFAULT 0,
        work_type TEXT,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (employee_id) REFERENCES $tableEmployees(id)
      )
    ''');

    // Create Holidays table
    await db.execute('''
      CREATE TABLE $tableHolidays (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        holiday_date TEXT NOT NULL,
        holiday_name TEXT NOT NULL,
        holiday_type TEXT,
        is_applicable_to_all INTEGER DEFAULT 1,
        branch_id INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create Users table
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        branch_id INTEGER,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create AuditLog table
    await db.execute('''
      CREATE TABLE $tableAuditLog (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        action TEXT NOT NULL,
        table_name TEXT,
        record_id INTEGER,
        old_value TEXT,
        new_value TEXT,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES $tableUsers(id)
      )
    ''');

    // Insert default data
    await _insertDefaultData(db);
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insert default branches
    await db.insert(tableBranches, {
      'name': 'شعبه اصلی',
      'location': 'تهران',
      'phone': '021-88888888',
    });

    await db.insert(tableBranches, {
      'name': 'شعبه دوم',
      'location': 'شیراز',
      'phone': '071-77777777',
    });

    await db.insert(tableBranches, {
      'name': 'شعبه سوم',
      'location': 'اصفهان',
      'phone': '031-66666666',
    });

    await db.insert(tableBranches, {
      'name': 'شعبه چهارم',
      'location': 'مشهد',
      'phone': '051-55555555',
    });

    // Insert default admin user
    await db.insert(tableUsers, {
      'username': 'admin',
      'password': 'admin123', // TODO: Hash password
      'full_name': 'مدیر سیستم',
      'role': 'admin',
      'is_active': 1,
    });

    // Insert default holidays (Iranian holidays)
    final holidays = [
      {'date': '1404-01-01', 'name': 'روز جمهوری اسلامی', 'type': 'national'},
      {'date': '1404-02-11', 'name': 'دهه فجر', 'type': 'national'},
      {'date': '1404-03-20', 'name': 'نوروز', 'type': 'national'},
    ];

    for (var holiday in holidays) {
      await db.insert(tableHolidays, {
        'holiday_date': holiday['date'],
        'holiday_name': holiday['name'],
        'holiday_type': holiday['type'],
        'is_applicable_to_all': 1,
      });
    }
  }

  // ==================== BRANCH OPERATIONS ====================
  Future<int> insertBranch(Branch branch) async {
    final db = await database;
    return await db.insert(tableBranches, branch.toMap());
  }

  Future<List<Branch>> getAllBranches() async {
    final db = await database;
    final maps = await db.query(tableBranches);
    return List.generate(maps.length, (i) => Branch.fromMap(maps[i]));
  }

  Future<Branch?> getBranchById(int id) async {
    final db = await database;
    final maps = await db.query(tableBranches, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Branch.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBranch(Branch branch) async {
    final db = await database;
    return await db.update(tableBranches, branch.toMap(), where: 'id = ?', whereArgs: [branch.id]);
  }

  Future<int> deleteBranch(int id) async {
    final db = await database;
    return await db.delete(tableBranches, where: 'id = ?', whereArgs: [id]);
  }

  // ==================== EMPLOYEE OPERATIONS ====================
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert(tableEmployees, employee.toMap());
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final maps = await db.query(tableEmployees, where: 'is_active = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) => Employee.fromMap(maps[i]));
  }

  Future<List<Employee>> getEmployeesByBranch(int branchId) async {
    final db = await database;
    final maps = await db.query(
      tableEmployees,
      where: 'branch_id = ? AND is_active = ?',
      whereArgs: [branchId, 1],
    );
    return List.generate(maps.length, (i) => Employee.fromMap(maps[i]));
  }

  Future<Employee?> getEmployeeById(int id) async {
    final db = await database;
    final maps = await db.query(tableEmployees, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Employee.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(tableEmployees, employee.toMap(), where: 'id = ?', whereArgs: [employee.id]);
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.update(
      tableEmployees,
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== CONTRACT OPERATIONS ====================
  Future<int> insertContract(Contract contract) async {
    final db = await database;
    return await db.insert(tableContracts, contract.toMap());
  }

  Future<Contract?> getContractByEmployeeId(int employeeId) async {
    final db = await database;
    final maps = await db.query(
      tableContracts,
      where: 'employee_id = ? AND is_active = ?',
      whereArgs: [employeeId, 1],
    );
    if (maps.isNotEmpty) {
      return Contract.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateContract(Contract contract) async {
    final db = await database;
    return await db.update(tableContracts, contract.toMap(), where: 'id = ?', whereArgs: [contract.id]);
  }

  // ==================== ATTENDANCE OPERATIONS ====================
  Future<int> insertAttendance(Attendance attendance) async {
    final db = await database;
    return await db.insert(tableAttendance, attendance.toMap());
  }

  Future<List<Attendance>> getAttendanceByEmployeeAndDate(int employeeId, DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(
      tableAttendance,
      where: 'employee_id = ? AND attendance_date = ?',
      whereArgs: [employeeId, dateStr],
    );
    return List.generate(maps.length, (i) => Attendance.fromMap(maps[i]));
  }

  Future<List<Attendance>> getAttendanceByEmployeeAndDateRange(int employeeId, DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];
    final maps = await db.query(
      tableAttendance,
      where: 'employee_id = ? AND attendance_date BETWEEN ? AND ?',
      whereArgs: [employeeId, startStr, endStr],
      orderBy: 'attendance_date DESC',
    );
    return List.generate(maps.length, (i) => Attendance.fromMap(maps[i]));
  }

  Future<int> updateAttendance(Attendance attendance) async {
    final db = await database;
    return await db.update(tableAttendance, attendance.toMap(), where: 'id = ?', whereArgs: [attendance.id]);
  }

  // ==================== LEAVE OPERATIONS ====================
  Future<int> insertLeave(Leave leave) async {
    final db = await database;
    return await db.insert(tableLeaves, leave.toMap());
  }

  Future<List<Leave>> getLeavesByEmployee(int employeeId) async {
    final db = await database;
    final maps = await db.query(
      tableLeaves,
      where: 'employee_id = ?',
      whereArgs: [employeeId],
      orderBy: 'start_date DESC',
    );
    return List.generate(maps.length, (i) => Leave.fromMap(maps[i]));
  }

  Future<List<Leave>> getPendingLeaves() async {
    final db = await database;
    final maps = await db.query(
      tableLeaves,
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Leave.fromMap(maps[i]));
  }

  Future<int> updateLeave(Leave leave) async {
    final db = await database;
    return await db.update(tableLeaves, leave.toMap(), where: 'id = ?', whereArgs: [leave.id]);
  }

  // ==================== WORK LOG OPERATIONS ====================
  Future<int> insertWorkLog(WorkLog workLog) async {
    final db = await database;
    return await db.insert(tableWorkLogs, workLog.toMap());
  }

  Future<List<WorkLog>> getWorkLogsByEmployeeAndDateRange(int employeeId, DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];
    final maps = await db.query(
      tableWorkLogs,
      where: 'employee_id = ? AND log_date BETWEEN ? AND ?',
      whereArgs: [employeeId, startStr, endStr],
      orderBy: 'log_date DESC',
    );
    return List.generate(maps.length, (i) => WorkLog.fromMap(maps[i]));
  }

  Future<int> updateWorkLog(WorkLog workLog) async {
    final db = await database;
    return await db.update(tableWorkLogs, workLog.toMap(), where: 'id = ?', whereArgs: [workLog.id]);
  }

  // ==================== HOLIDAY OPERATIONS ====================
  Future<int> insertHoliday(Holiday holiday) async {
    final db = await database;
    return await db.insert(tableHolidays, holiday.toMap());
  }

  Future<List<Holiday>> getAllHolidays() async {
    final db = await database;
    final maps = await db.query(tableHolidays, orderBy: 'holiday_date DESC');
    return List.generate(maps.length, (i) => Holiday.fromMap(maps[i]));
  }

  Future<Holiday?> getHolidayByDate(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(tableHolidays, where: 'holiday_date = ?', whereArgs: [dateStr]);
    if (maps.isNotEmpty) {
      return Holiday.fromMap(maps.first);
    }
    return null;
  }

  // ==================== USER OPERATIONS ====================
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      tableUsers,
      where: 'username = ? AND is_active = ?',
      whereArgs: [username, 1],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(tableUsers, user);
  }

  // ==================== STATISTICS ====================
  Future<int> getTodayPresentCount(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableAttendance WHERE attendance_date = ? AND status = ?',
      [dateStr, 'present'],
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getTodayAbsentCount(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableAttendance WHERE attendance_date = ? AND status = ?',
      [dateStr, 'absent'],
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<Map<String, dynamic>> getEmployeeStatistics(int employeeId, int monthYear) async {
    final db = await database;
    
    final attendanceResult = await db.rawQuery(
      '''SELECT status, COUNT(*) as count FROM $tableAttendance 
         WHERE employee_id = ? AND strftime('%Y-%m', attendance_date) = ? 
         GROUP BY status''',
      [employeeId, monthYear],
    );

    Map<String, int> stats = {
      'present': 0,
      'absent': 0,
      'late': 0,
      'early_leave': 0,
    };

    for (var row in attendanceResult) {
      stats[row['status'] as String] = (row['count'] as int?) ?? 0;
    }

    final workLogsResult = await db.rawQuery(
      '''SELECT SUM(worked_hours) as total_worked, SUM(overtime_hours) as total_overtime, 
         SUM(deduction_hours) as total_deduction FROM $tableWorkLogs 
         WHERE employee_id = ? AND strftime('%Y-%m', log_date) = ?''',
      [employeeId, monthYear],
    );

    return {
      'attendance': stats,
      'worked_hours': (workLogsResult.first['total_worked'] as num?) ?? 0.0,
      'overtime_hours': (workLogsResult.first['total_overtime'] as num?) ?? 0.0,
      'deduction_hours': (workLogsResult.first['total_deduction'] as num?) ?? 0.0,
    };
  }

  // ==================== DATABASE MAINTENANCE ====================
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(tableAttendance);
    await db.delete(tableLeaves);
    await db.delete(tableWorkLogs);
    await db.delete(tableContracts);
    await db.delete(tableEmployees);
  }
}
