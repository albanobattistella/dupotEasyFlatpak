import 'dart:convert';
import 'dart:io';

class UserSettingsEntity {
  int version = 0;

  String jsonUserSettingsPath = '';

  String applicationDataPath = '';
  String applicationIconPath = '';

  bool userOverrideLanguageCode = false;
  String languageCode = 'en';
  bool userOverrideDarkModeEnabled = false;
  bool darkModeEnabled = false;
  bool userInstallationScopeEnabled = false;

  static final UserSettingsEntity _singleton = UserSettingsEntity._internal();

  factory UserSettingsEntity([String? newJsonUserSettingsPath]) {
    if (newJsonUserSettingsPath != null && newJsonUserSettingsPath.isNotEmpty) {
      _singleton.jsonUserSettingsPath = newJsonUserSettingsPath;
      File jsonParametersFile = File(_singleton.jsonUserSettingsPath);
      if (jsonParametersFile.existsSync()) {
        String jsonParameterString = jsonParametersFile.readAsStringSync();
        Map<String, dynamic> jsonParameterObj = jsonDecode(jsonParameterString);
        for (String mandatoryFieldLoop in [
          'version',
          'applicationDataPath',
          'userOverrideLanguageCode',
          'languageCode',
          'userOverrideDarkModeEnabled',
          'darkModeEnabled',
          'userInstallationScopeEnabled'
        ]) {
          if (!jsonParameterObj.containsKey(mandatoryFieldLoop)) {
            throw Exception(
                'Missing mandatory userSettings $mandatoryFieldLoop field in $newJsonUserSettingsPath');
          }
        }
        _singleton.version = jsonParameterObj['version'];
        _singleton.applicationDataPath =
            jsonParameterObj['applicationDataPath'];
        _singleton.userOverrideLanguageCode =
            jsonParameterObj['userOverrideLanguageCode'];
        _singleton.userOverrideDarkModeEnabled =
            jsonParameterObj['userOverrideDarkModeEnabled'];

        if (_singleton.userOverrideLanguageCode) {
          _singleton.languageCode = jsonParameterObj['languageCode'];
        }

        if (_singleton.userOverrideDarkModeEnabled) {
          _singleton.darkModeEnabled = jsonParameterObj['darkModeEnabled'];
        }

        _singleton.userInstallationScopeEnabled =
            jsonParameterObj['userInstallationScopeEnabled'];
      }
    }
    return _singleton;
  }

  UserSettingsEntity._internal();

  void setApplicationDataPath(String newApplicationDataPath) {
    applicationDataPath = newApplicationDataPath;
    applicationIconPath = "$applicationDataPath/icons";
  }

  String getApplicationDataPath() {
    return applicationDataPath;
  }

  String getApplicationIconsPath() {
    return applicationIconPath;
  }

  void setSystemDarkModeEnabled(bool newDarkModeEnabled) {
    if (!userOverrideDarkModeEnabled) {
      darkModeEnabled = newDarkModeEnabled;
    }
  }

  Future<void> setLanguageCode(String newLanguageCode) async {
    languageCode = newLanguageCode;
    await save();
  }

  Future<void> setDarModeEnabled(bool newDarkModeEnabled) async {
    darkModeEnabled = newDarkModeEnabled;
    await save();
  }

  Future<void> setUserInstallationScopeEnabled(
      bool newUserInstallationScopeEnabled) async {
    userInstallationScopeEnabled = newUserInstallationScopeEnabled;
    await save();
  }

  String getLanguageCode() {
    return languageCode;
  }

  bool getDarkModeEnabled() {
    return darkModeEnabled;
  }

  bool getUserInstallationScopeEnabled() {
    return userInstallationScopeEnabled;
  }

  String getInstallationScope() {
    if (userInstallationScopeEnabled) {
      return '--user';
    }
    return '--system';
  }

  Future<void> save() async {
    Map<String, dynamic> jsonParameterObj = {
      'userOverrideLanguageCode': userOverrideLanguageCode,
      'languageCode': languageCode,
      'userOverrideDarkModeEnabled': userOverrideDarkModeEnabled,
      'darkModeEnabled': darkModeEnabled,
      'userInstallationScopeEnabled': userInstallationScopeEnabled
    };

    File jsonParameterFile = File(jsonUserSettingsPath);
    jsonParameterFile.writeAsStringSync(jsonEncode(jsonParameterObj));
  }
}
