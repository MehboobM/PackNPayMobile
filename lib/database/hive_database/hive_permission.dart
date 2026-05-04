

import 'package:hive/hive.dart';

import '../../models/permission_model.dart';

class AuthHiveService {
  static final box = Hive.box('authBox');

  /// SAVE FULL RESPONSE
  static Future<void> saveResponse(Map<String, dynamic> response) async {
    await box.put('auth_response', response);
  }

  /// GET FULL RESPONSE
  static Map<String, dynamic>? getResponse() {
    final data = box.get('auth_response');
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }


  static String getUserRole() {
    final data = getResponse();
    if (data == null || data['user'] == null) return "";

    return (data['user']['role'] ?? "").toString().toLowerCase();
  }


  static bool shouldCheckPermission() {
    final role = getUserRole();
    print("roll is >>>>>>>>>>>>>>>$role");
    return role == "staff" ||
        role == "manager" ||
        role == "supervisor"; // fix spelling if needed
  }


  /// GET PERMISSIONS LIST
  static List<PermissionModel> getPermissions() {
    final data = getResponse();
    if (data == null || data['permissions'] == null) return [];

    return (data['permissions'] as List).map((e) => PermissionModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// CHECK PERMISSION (important 🔥)
  static bool canView(String moduleCode) {
    final permissions = getPermissions();
    final module = permissions.firstWhere((e) => e.moduleCode == moduleCode,
      orElse: () => PermissionModel(
        moduleCode: '',
        moduleName: '',
        canView: 0,
        canAdd: 0,
        canEdit: 0,
        canDelete: 0,
      ),
    );

    return module.canView == 1;
  }

  static PermissionModel getPermission(String moduleCode) {
    final permissions = getPermissions();

    return permissions.firstWhere(
          (e) => e.moduleCode == moduleCode,
      orElse: () => PermissionModel(
        moduleCode: moduleCode,
        moduleName: '',
        canView: 0,
        canAdd: 0,
        canEdit: 0,
        canDelete: 0,
      ),
    );
  }

  // final surveyPermission = AuthHiveService.getPermission("SURVEY");
// print(surveyPermission.canView);
// print(surveyPermission.canAdd);


// i have added two but add for all create helper:
  bool hasQuotationAccess = AuthHiveService.canView("QUOTATION");
  bool hasOrderAccess = AuthHiveService.canView("ORDER");

  /// CLEAR
  static Future<void> clear() async {
    await box.delete('auth_response');
  }
}


enum ModuleCode {
  survey,
  quotation,
  order,
  moneyReceipt,
  staff,
  expense,
  lr,
  letterHead,

  // ✅ NEW MODULES
  home,
  subscription,
  business,
  accounting,
  download,
  helpLine,
  support,
  helpSupport,
  userProfile,
  complaints,
  vendor,
  items,
}

extension ModuleCodeExtension on ModuleCode {
  String get value {
    switch (this) {
      case ModuleCode.survey:
        return "SURVEY";
      case ModuleCode.quotation:
        return "QUOTATION";
      case ModuleCode.order:
        return "ORDER";
      case ModuleCode.moneyReceipt:
        return "MONEY_RECEIPT";
      case ModuleCode.staff:
        return "STAFF";
      case ModuleCode.expense:
        return "EXPENSE";
      case ModuleCode.lr:
        return "LR";
      case ModuleCode.letterHead:
        return "LETTER_HEAD";

    // ✅ NEW CASES
      case ModuleCode.home:
        return "HOME";
      case ModuleCode.subscription:
        return "SUBSCRIPTION";
      case ModuleCode.business:
        return "BUSINESS";
      case ModuleCode.accounting:
        return "ACCOUNTING";
      case ModuleCode.download:
        return "DOWNLOAD";
      case ModuleCode.helpLine:
        return "HELP_LINE";
      case ModuleCode.support:
        return "SUPPORT";
      case ModuleCode.helpSupport:
        return "HELP_SUPPORT";
      case ModuleCode.userProfile:
        return "USER_PROFILE";
      case ModuleCode.complaints:
        return "COMPLAINTS";
      case ModuleCode.vendor:
        return "VENDOR";
      case ModuleCode.items:
        return "ITEMS";
    }
  }
}


class PermissionHelper {

  static bool canView(ModuleCode module) {
    if (!AuthHiveService.shouldCheckPermission()) return true;

    return AuthHiveService.getPermission(module.value).canView == 1;
  }

  static bool canAdd(ModuleCode module) {
    if (!AuthHiveService.shouldCheckPermission()) return true;

    return AuthHiveService.getPermission(module.value).canAdd == 1;
  }

  static bool canEdit(ModuleCode module) {
    if (!AuthHiveService.shouldCheckPermission()) return true;

    return AuthHiveService.getPermission(module.value).canEdit == 1;
  }

  static bool canDelete(ModuleCode module) {
    if (!AuthHiveService.shouldCheckPermission()) return true;

    return AuthHiveService.getPermission(module.value).canDelete == 1;
  }
}




// if (PermissionHelper.canView(ModuleCode.quotation)) {
//   // show quotation
// }
//
// ElevatedButton(
//   onPressed: PermissionHelper.canAdd(ModuleCode.order)
//       ? () {}
//       : null,
//   child: Text("Add Order"),
// );
