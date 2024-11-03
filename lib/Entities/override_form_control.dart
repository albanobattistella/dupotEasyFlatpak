import 'package:flutter/material.dart';

class OverrideFormControl {
  late String label;
  late String type;
  late String value;

  late bool boolValue = false;

  TextEditingController textEditingController = TextEditingController();

  static const String constFileSystem = 'filesystem';
  static const String constInstallFlatpak = 'installFlatpak';

  void setLabel(String label) {
    this.label = label;
  }

  bool isTypeFileSystem() {
    return type == constFileSystem;
  }

  bool isTypeInstallFlatpak() {
    return type == constInstallFlatpak;
  }

  void setType(String type) {
    if (['filesystem_noprompt', 'filesystem'].contains(type)) {
      this.type = constFileSystem;
      return;
    } else if (type == 'install_flatpak_yesno') {
      this.type = constInstallFlatpak;
      return;
    }
    throw Exception('OverrideFormControl setType "$type" not implemented');
  }

  void setValue(String value) {
    textEditingController.text = value;
    this.value = value;
  }

  String getValue() {
    return textEditingController.text;
  }
}
