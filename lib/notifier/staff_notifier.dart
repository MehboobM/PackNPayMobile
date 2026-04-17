import 'package:flutter/material.dart';
import '../models/staff_user_model.dart';
import '../repositry/userstaff_repository.dart';

class StaffNotifier extends ChangeNotifier {
  final UserRepository _userRepository;

  StaffNotifier(this._userRepository) {
    fetchUsers();
  }

  List<UserModel> _allStaff = [];
  List<UserModel> _filteredStaff = [];

  List<UserModel> get filteredStaff => _filteredStaff;

  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;

  // 🔹 Fetch users from API
  Future<void> fetchUsers() async {
    try {
      _allStaff = await _userRepository.getUserList();
      applyFilters();
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  // 🔹 Update search query
  void updateSearch(String query) {
    _searchQuery = query.toLowerCase();
    applyFilters();
  }

  // 🔹 Update date range
  void updateDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    applyFilters();
  }
  Future<void> deleteStaff(String uid) async {
    final index = _allStaff.indexWhere((user) => user.uid == uid);
    if (index == -1) return;

    final removedUser = _allStaff[index];

    // 🔹 Optimistic UI Update
    _allStaff.removeAt(index);
    applyFilters();

    try {
      await _userRepository.deleteUser(uid);
    } catch (e) {
      // 🔹 Rollback if API fails
      _allStaff.insert(index, removedUser);
      applyFilters();
      print("Delete failed: $e");
      rethrow;
    }
  }

  // 🔹 Apply search + date filters
  void applyFilters() {
    _filteredStaff = _allStaff.where((user) {
      final name = user.name?.toLowerCase() ?? "";
      final role = user.role?.toLowerCase() ?? "";

      bool matchesSearch =
          name.contains(_searchQuery) ||
              role.contains(_searchQuery);

      bool matchesDate = true;

      if (_fromDate != null && _toDate != null && user.joiningDate != null) {
        final joining = DateTime.tryParse(user.joiningDate!);

        if (joining != null) {
          matchesDate =
              joining.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
                  joining.isBefore(_toDate!.add(const Duration(days: 1)));
        }
      }

      return matchesSearch && matchesDate;
    }).toList();

    notifyListeners();
  }
  Future<void> toggleStatus(UserModel user) async {
    final index = _allStaff.indexWhere((u) => u.uid == user.uid);
    if (index == -1) return;

    final oldUser = _allStaff[index];

    // 🔹 Optimistic update
    final updatedUser = oldUser.copyWith(
      status: oldUser.status == "ACTIVE" ? "INACTIVE" : "ACTIVE",
    );

    _allStaff[index] = updatedUser;
    applyFilters();

    try {
      await _userRepository.toggleUserStatus(user.uid);
    } catch (e) {
      // 🔹 rollback if API fails
      _allStaff[index] = oldUser;
      applyFilters();
      print("Toggle failed: $e");
    }
  }
}