import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/staff_user_model.dart';
import '../models/staff_details_modal.dart';
import '../repositry/userstaff_repository.dart';

class StaffNotifier extends ChangeNotifier {
  final UserRepository _userRepository;

  StaffNotifier(this._userRepository) {
    fetchUsers();
    fetchStaffList();
  }

  // ================= LIST DATA =================
  List<UserModel> _allStaff = [];
  List<UserModel> _filteredStaff = [];

  List<UserModel> get filteredStaff => _filteredStaff;

  List<Map<String, dynamic>> _staffList = [];
  List<Map<String, dynamic>> get staffList => _staffList;

  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _sortOrder;
  int? _staffId;

  Timer? _debounce;

  // ================= DETAILS DATA =================
  UserDetailsModel? _selectedUserDetails;
  UserDetailsModel? get selectedUserDetails => _selectedUserDetails;

  bool _isDetailsLoading = false;
  bool get isDetailsLoading => _isDetailsLoading;

  // ================= FETCH STAFF LIST =================
  Future<void> fetchStaffList() async {
    try {
      _staffList = await _userRepository.getStaffList();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff list: $e");
    }
  }

  // ================= FETCH USERS (LIST) =================
  Future<void> fetchUsers() async {
    try {
      final from = _fromDate != null
          ? DateFormat('yyyy-MM-dd').format(_fromDate!)
          : null;

      final to = _toDate != null
          ? DateFormat('yyyy-MM-dd').format(_toDate!)
          : null;

      _allStaff = await _userRepository.getUserListWithFilters(
        search: _searchQuery,
        fromDate: from,
        toDate: to,
        sortBy: "created_at",
        sortOrder: _sortOrder,
        staffId: _staffId,
      );

      _filteredStaff = _allStaff;
      notifyListeners();
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  // ================= DETAILS API =================
  Future<void> fetchUserDetails(String uid) async {
    try {
      _isDetailsLoading = true;
      notifyListeners();

      final data = await _userRepository.getUserByUid(uid);

      _selectedUserDetails = UserDetailsModel.fromJson(data);

      _isDetailsLoading = false;
      notifyListeners();
    } catch (e) {
      _isDetailsLoading = false;
      notifyListeners();
      print("DETAIL FETCH ERROR => $e");
    }
  }

  // ================= SEARCH =================
  void updateSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchQuery = query;
      fetchUsers();
    });
  }

  // ================= DATE FILTER =================
  void updateDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    fetchUsers();
  }

  // ================= SORT =================
  void updateSort(String? sortOrder) {
    _sortOrder = sortOrder;
    fetchUsers();
  }

  // ================= STAFF FILTER =================
  void updateStaff(int? staffId) {
    _staffId = staffId;
    fetchUsers();
  }

  // ================= DELETE =================
  Future<void> deleteStaff(String uid) async {
    final index = _allStaff.indexWhere((user) => user.uid == uid);
    if (index == -1) return;

    final removedUser = _allStaff[index];

    _allStaff.removeAt(index);
    _filteredStaff = _allStaff;
    notifyListeners();

    try {
      await _userRepository.deleteUser(uid);
    } catch (e) {
      _allStaff.insert(index, removedUser);
      _filteredStaff = _allStaff;
      notifyListeners();
      print("Delete failed: $e");
      rethrow;
    }
  }

  // ================= TOGGLE STATUS =================
  Future<void> toggleStatus(UserModel user) async {
    final index = _allStaff.indexWhere((u) => u.uid == user.uid);
    if (index == -1) return;

    final oldUser = _allStaff[index];

    final updatedUser = oldUser.copyWith(
      status: oldUser.status == "ACTIVE" ? "INACTIVE" : "ACTIVE",
    );

    _allStaff[index] = updatedUser;
    _filteredStaff = _allStaff;
    notifyListeners();

    try {
      await _userRepository.toggleUserStatus(user.uid);
    } catch (e) {
      _allStaff[index] = oldUser;
      _filteredStaff = _allStaff;
      notifyListeners();
      print("Toggle failed: $e");
    }
  }

  // ================= GETTERS =================
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  String? get sortOrder => _sortOrder;
  int? get staffId => _staffId;
}