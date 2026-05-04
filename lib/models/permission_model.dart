

class PermissionModel {
  final String moduleCode;
  final String moduleName;
  final int canView;
  final int canAdd;
  final int canEdit;
  final int canDelete;

  PermissionModel({
    required this.moduleCode,
    required this.moduleName,
    required this.canView,
    required this.canAdd,
    required this.canEdit,
    required this.canDelete,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      moduleCode: json['module_code'],
      moduleName: json['module_name'],
      canView: json['can_view'],
      canAdd: json['can_add'],
      canEdit: json['can_edit'],
      canDelete: json['can_delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "module_code": moduleCode,
      "module_name": moduleName,
      "can_view": canView,
      "can_add": canAdd,
      "can_edit": canEdit,
      "can_delete": canDelete,
    };
  }
}