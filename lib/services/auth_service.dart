import '../database/db_helper.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Login user
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final user = await _dbHelper.getUserByUsername(username);
      
      if (user != null) {
        // TODO: Hash password comparison
        if (user['password'] == password) {
          return {
            'id': user['id'],
            'username': user['username'],
            'full_name': user['full_name'],
            'role': user['role'],
            'branch_id': user['branch_id'],
          };
        }
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Register user
  Future<bool> registerUser(String username, String password, String fullName, String role) async {
    try {
      await _dbHelper.insertUser({
        'username': username,
        'password': password, // TODO: Hash password
        'full_name': fullName,
        'role': role,
        'is_active': 1,
      });
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Verify username exists
  Future<bool> usernameExists(String username) async {
    try {
      final user = await _dbHelper.getUserByUsername(username);
      return user != null;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }
}
