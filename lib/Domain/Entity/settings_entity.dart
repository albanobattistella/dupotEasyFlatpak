import 'dart:convert';

import 'package:flutter/services.dart';

class Settings {
  late Map<String, dynamic> settingsObj;

  Future<void> load() async {
    String settingsString = await rootBundle.loadString("assets/settings.json");
    settingsObj = Map<String, dynamic>.from(json.decode(settingsString));
  }

  bool useFlatpakSpawn() {
    if (settingsObj.containsKey('useFlatpakSpawn')) {
      return settingsObj['useFlatpakSpawn'];
    }
    return false;
  }

  String getFlatpakSpawnCommand() {
    return 'flatpak-spawn';
  }
}
