import 'package:dupot_easy_flatpak/Entities/override_form_control.dart';
import 'package:dupot_easy_flatpak/Models/permission.dart';
import 'package:dupot_easy_flatpak/Models/recipe.dart';
import 'package:dupot_easy_flatpak/Models/recipe_factory.dart';
import 'package:dupot_easy_flatpak/Process/commands.dart';
import 'package:ini/ini.dart';

class OverrideControl {
  Config overrideConfig = Config();

  static const String constFileSystems = 'filesystems';

  List<String> overridedFileSystemList = [];
  int overridedFileSystemIndex = 0;

  Future<List<OverrideFormControl>> getOverrideControlList(
      applicationId) async {
    await loadOverrideConfig(applicationId);

    Recipe recipe = await RecipeFactory().getApplication(applicationId);

    List<OverrideFormControl> overrideFormControlList = [];

    List<Permission> recipePermissionList =
        recipe.getFlatpakPermissionToOverrideList();

    for (Permission recipePermissionLoop in recipePermissionList) {
      OverrideFormControl overrideFormControlLoop = OverrideFormControl();
      overrideFormControlLoop.setLabel(recipePermissionLoop.label);

      String textValue = await getOverridedConfig(recipePermissionLoop.type);

      overrideFormControlLoop.setValue(textValue);

      overrideFormControlLoop.setType(recipePermissionLoop.type);

      overrideFormControlList.add(overrideFormControlLoop);
    }

    return overrideFormControlList;
  }

  Future<void> loadOverrideConfig(applicationId) async {
    FlatpakOverrideApplication flatpakOverrideApplication =
        await Commands().isApplicationOverrided(applicationId);

    overrideConfig = Config.fromStrings(
        flatpakOverrideApplication.flatpakOutput.toString().split("\n"));
  }

  Future<String> getOverridedConfig(String type) async {
    if (['filesystem_noprompt', 'filesystem'].contains(type)) {
      if (overridedFileSystemList.isEmpty) {
        overridedFileSystemList = overrideConfig
            .get('Context', constFileSystems)
            .toString()
            .split(';');
      }

      String overridedFileSystemFound =
          overridedFileSystemList[overridedFileSystemIndex];

      overridedFileSystemIndex++;

      return overridedFileSystemFound;
    }

    throw Exception('getOverridedConfig for type "$type" Not implemented');
  }

  Future<void> save(String applicationId,
      List<OverrideFormControl> overrideFormControlList) async {
    List<String> parameterFilesystemToOverrideList = [];
    for (OverrideFormControl overrideFormControlLoop
        in overrideFormControlList) {
      if (overrideFormControlLoop.isTypeFileSystem()) {
        parameterFilesystemToOverrideList
            .add(overrideFormControlLoop.textEditingController.text);
      } else {
        throw Exception(
            'save overrideFormControlLoop.type ${overrideFormControlLoop.type} not implemented ');
      }
    }
    print('-------------SAVE--------------');

    await Commands().runProcess(
        'flatpak', ['override', '--user', '--reset', applicationId]);

    for (String parameterFilesystemToOverrideLoop
        in parameterFilesystemToOverrideList) {
      List<String> argList = [
        'override',
        '--user',
      ];

      argList.add('--filesystem=$parameterFilesystemToOverrideLoop');

      argList.add(applicationId);

      await Commands().runProcess('flatpak', argList);
    }
  }
}
