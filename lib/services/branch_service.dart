import '../database/db_helper.dart';
import '../models/branch.dart';

class BranchService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get all branches
  Future<List<Branch>> getAllBranches() async {
    try {
      return await _dbHelper.getAllBranches();
    } catch (e) {
      print('Error getting branches: $e');
      return [];
    }
  }

  // Get branch by id
  Future<Branch?> getBranchById(int id) async {
    try {
      return await _dbHelper.getBranchById(id);
    } catch (e) {
      print('Error getting branch: $e');
      return null;
    }
  }

  // Add new branch
  Future<bool> addBranch(Branch branch) async {
    try {
      await _dbHelper.insertBranch(branch);
      return true;
    } catch (e) {
      print('Error adding branch: $e');
      return false;
    }
  }

  // Update branch
  Future<bool> updateBranch(Branch branch) async {
    try {
      await _dbHelper.updateBranch(branch);
      return true;
    } catch (e) {
      print('Error updating branch: $e');
      return false;
    }
  }

  // Delete branch
  Future<bool> deleteBranch(int id) async {
    try {
      await _dbHelper.deleteBranch(id);
      return true;
    } catch (e) {
      print('Error deleting branch: $e');
      return false;
    }
  }
}
