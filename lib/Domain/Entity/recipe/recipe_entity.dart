import 'package:dupot_easy_flatpak/Domain/Entity/recipe/permission_entity.dart';

class RecipeEntity {
  String id = '';
  List<PermissionEntity> flatpakPermissionToOverrideList = [];

  RecipeEntity(String applicationId,
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

      flatpakPermissionToOverrideList.add(PermissionEntity(
          rawPermissionLoop['type'].toString(),
          rawPermissionLoop['label']!,
          value,
          subValueYes,
          subValueNo));
    }
  }

  List<PermissionEntity> getFlatpakPermissionToOverrideList() {
    return flatpakPermissionToOverrideList;
  }
}
