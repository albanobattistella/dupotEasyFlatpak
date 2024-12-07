import 'dart:async';
import 'dart:io';

import 'package:dupot_easy_flatpak/Domain/Entity/application_installed_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/application_update_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/settings_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';

class CommandApi {
  static const String flatpakCommand = 'flatpak';

  late Settings settingsObj;
  late String updatesAvailableOutput;
  List<ApplicationUpdate> ApplicationUpdateAvailableList = [];
  List<String> dbApplicationIdList = [];
  List<ApplicationInstalledEntity> ApplicationInstalledList = [];

  static final CommandApi _singleton = CommandApi._internal();

  factory CommandApi([Settings? settingsObj]) {
    if (settingsObj != null) {
      _singleton.settingsObj = settingsObj;
    }
    return _singleton;
  }

  CommandApi._internal();

  bool isInsideFlatpak() {
    return settingsObj.useFlatpakSpawn();
  }

  Future<bool> missFlathubInFlatpak() async {
    ProcessResult result = await runProcessSync('flatpak', ['remotes']);
    if (result.stdout.toString().contains('flathub')) {
      return false;
    }
    return true;
  }

  void setDbApplicationIdList(List<String> dbApplicationIdList) {
    this.dbApplicationIdList = dbApplicationIdList;
  }

  int getNumberOfUpdates() {
    return ApplicationUpdateAvailableList.length;
  }

  List<String> getAppIdUpdateAvailableList() {
    List<String> appIdList = [];
    for (ApplicationUpdate ApplicationUpdateLoop
        in ApplicationUpdateAvailableList) {
      appIdList.add(ApplicationUpdateLoop.id.toLowerCase());
    }
    return appIdList;
  }

  Future<String> updateFlatpak(String appId) async {
    ProcessResult result = await runProcess('flatpak', ['update', '-y', appId]);
    return result.stdout.toString();
  }

  bool hasApplicationInDatabase(String appId) {
    return dbApplicationIdList.contains(appId.toLowerCase());
  }

  Future<List<ApplicationUpdate>> checkUpdates() async {
    ProcessResult result = await runProcess('flatpak', ['--no-deps', 'update']);
    updatesAvailableOutput = result.stdout.toString();

    ApplicationUpdateAvailableList.clear();

    List<String> lineList = updatesAvailableOutput.split("\n");

    if (lineList.isNotEmpty) {
      for (String lineLoop in lineList) {
        if (RegExp(r'\t').hasMatch(lineLoop) && lineLoop.contains('flathub')) {
          List<String> lineLoopList = lineLoop.split("\t");

          String appId = lineLoopList[2].toLowerCase();
          String comment = lineLoopList[3];
          if (lineLoopList.length > 5) {
            comment = "${lineLoopList[3]} (${lineLoopList[6]})";
          }
          ApplicationUpdateAvailableList.add(ApplicationUpdate(appId, comment));
        }
      }
    }

    return ApplicationUpdateAvailableList;
  }

  bool hasApplicationInstalledVersionDifferentThan(
      String appId, String versionToUpdate) {
    for (ApplicationInstalledEntity ApplicationInstalledLoop
        in ApplicationInstalledList) {
      if (ApplicationInstalledLoop.id == appId &&
          ApplicationInstalledLoop.version != versionToUpdate) {
        return true;
      }
    }
    return false;
  }

  bool hasUpdateAvailableByAppId(String appId) {
    for (ApplicationUpdate ApplicationUpdateAvailableLoop
        in ApplicationUpdateAvailableList) {
      if (ApplicationUpdateAvailableLoop.id == appId.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  String getApplicationUpdateVersionByAppId(String appId) {
    for (ApplicationUpdate ApplicationUpdateAvailableLoop
        in ApplicationUpdateAvailableList) {
      if (ApplicationUpdateAvailableLoop.id == appId.toLowerCase()) {
        return ApplicationUpdateAvailableLoop.version;
      }
    }
    throw Exception('Cannot find app version available for id: $appId');
  }

  Future<void> setupFlathub() async {
    await runProcessSync('flatpak', [
      'remote-add',
      '--if-not-exists',
      'flathub',
      'https://flathub.org/repo/flathub.flatpakrepo'
    ]);
  }

  String getCommand(String command) {
    if (isInsideFlatpak()) {
      return settingsObj.getFlatpakSpawnCommand();
    }
    return command;
  }

  Future<ProcessResult> runProcess(
      String command, List<String> argumentList) async {
    return await Process.run(getCommand(command),
        getFlatpakSpawnArgumentList(command, argumentList));
  }

  Future<ProcessResult> runProcessSync(
      String command, List<String> argumentList) async {
    return Process.runSync(getCommand(command),
        getFlatpakSpawnArgumentList(command, argumentList));
  }

  List<String> getFlatpakSpawnArgumentList(
      String command, List<String> subArgumentList) {
    if (isInsideFlatpak()) {
      List<String> argumentList = [];
      argumentList.add('--host');
      argumentList.add(command);

      for (String subArgumentLoop in subArgumentList) {
        argumentList.add(subArgumentLoop);
      }
      return argumentList;
    }
    return subArgumentList;
  }

  Future<void> loadApplicationInstalledList() async {
    ProcessResult result =
        await runProcess('flatpak', ['list', '--columns=application,version']);
    String ApplicationInstalledOutput = result.stdout.toString();

    ApplicationInstalledList.clear();

    List<String> lineList = ApplicationInstalledOutput.split("\n");
    if (lineList.isNotEmpty) {
      for (String lineLoop in lineList) {
        if (RegExp(r'\t').hasMatch(lineLoop)) {
          List<String> lineLoopList = lineLoop.split("\t");

          if (hasApplicationInDatabase(lineLoopList[0])) {
            ApplicationInstalledList.add(
                ApplicationInstalledEntity(lineLoopList[0], lineLoopList[1]));
          }
        }
      }
    }
  }

  Future<FlatpakApplication> isApplicationAlreadyInstalled(
      String applicationId) async {
    ProcessResult result =
        await runProcess(flatpakCommand, ['info', applicationId]);

    stdout.write(result.stdout);

    var isAlreadyInstalled = false;

    if (result.stdout.toString().length > 2) {
      isAlreadyInstalled = true;
    }

    return FlatpakApplication(isAlreadyInstalled, result.stdout.toString());
  }

  Future<FlatpakOverrideApplication> isApplicationOverrided(
      String applicationId) async {
    ProcessResult result = await runProcess(
        flatpakCommand, ['override', '--show', '--user', applicationId]);

    stdout.write(result.stdout);

    var isOverrided = false;

    print('stdout override');
    print(result.stdout.toString());
    print('stdout override FIN');

    if (result.stdout.toString().length > 2) {
      isOverrided = true;
    }

    return FlatpakOverrideApplication(isOverrided, result.stdout.toString());
  }

  Future<String> installApplicationThenOverrideList(
      String applicationId, List<List<String>> subProcessList) async {
    ProcessResult result = await runProcess(flatpakCommand, [
      'install',
      '-y',
      'flathub',
      UserSettingsEntity().getInstallationScope(),
      applicationId
    ]);

    stdout.write(result.stdout);
    stderr.write(result.stderr);

    for (List<String> argListLoop in subProcessList) {
      await runProcess(flatpakCommand, argListLoop);
    }

    return result.stdout.toString();
  }

  Future<String> uninstallApplicationThenOverrideList(
      String applicationId, List<List<String>> subProcessList) async {
    ProcessResult result = await runProcess(flatpakCommand, [
      'uninstall',
      '-y',
      UserSettingsEntity().getInstallationScope(),
      applicationId
    ]);

    stdout.write(result.stdout);
    stderr.write(result.stderr);

    return result.stdout.toString();
  }

  Future<List<String>> getInstalledApplicationList() async {
    ProcessResult result =
        await runProcessSync(flatpakCommand, ['list', '--columns=application']);

    String outputString = result.stdout;

    List<String> appIdList = [];
    List<String> lineList = outputString.split('\n');
    for (String lineLoop in lineList) {
      appIdList.add(lineLoop.toLowerCase());
    }

    return appIdList;
  }

  Future<void> run(String applicationId) async {
    runProcess(flatpakCommand, ['run', applicationId]);
  }
}

class FlatpakApplication {
  final bool isInstalled;
  final String flatpakOutput;

  FlatpakApplication(this.isInstalled, this.flatpakOutput);
}

class FlatpakOverrideApplication {
  final bool isOverrided;
  final String flatpakOutput;

  FlatpakOverrideApplication(this.isOverrided, this.flatpakOutput);
}
