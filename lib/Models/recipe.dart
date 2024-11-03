import 'package:dupot_easy_flatpak/Models/permission.dart';

class Recipe {
  String id = '';
  List<Permission> flatpakPermissionToOverrideList = [];

  Recipe(String applicationId,
      List<Map<String, dynamic>> rawFlatpakPermissionToOverrideList) {
    id = applicationId;
    for (Map<String, dynamic> rawPermissionLoop
        in rawFlatpakPermissionToOverrideList) {
      String value = "none";
      if (rawPermissionLoop.containsKey('value')) {
        value = rawPermissionLoop['value'];
      }
      String subValueYes = "";
      String subValueNo = "";

      if (rawPermissionLoop.containsKey('subValueYes')) {
        subValueYes = rawPermissionLoop['subValueYes'];
      }
      if (rawPermissionLoop.containsKey('subValueNo')) {
        subValueNo = rawPermissionLoop['subValueNo'];
      }

      flatpakPermissionToOverrideList.add(Permission(
          rawPermissionLoop['type'].toString(),
          rawPermissionLoop['label']!,
          value,
          subValueYes,
          subValueNo));
    }
  }

  List<Permission> getFlatpakPermissionToOverrideList() {
    return flatpakPermissionToOverrideList;
  }
}
