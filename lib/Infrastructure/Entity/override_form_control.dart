import 'package:flutter/material.dart';

class OverrideFormControl {
  late String label;
  late String type;
  late String value;

  late bool boolValue = false;

  String subValueYes = '';
  String subValueNo = '';

  TextEditingController textEditingController = TextEditingController();

  static const String constFileSystem = 'filesystem';
  static const String constInstallFlatpak = 'installFlatpak';
  static const String constEnv = 'env';

  void setLabel(String label) {
    this.label = label;
  }

  bool isTypeFileSystem() {
    return type == constFileSystem;
  }

  bool isTypeInstallFlatpak() {
    return type == constInstallFlatpak;
  }

  bool isTypeEnv() {
    return type == constEnv;
  }

  void setType(String type) {
    if (['filesystem_noprompt', 'filesystem'].contains(type)) {
      this.type = constFileSystem;
      return;
    } else if (type == 'install_flatpak_yesno') {
      this.type = constInstallFlatpak;
      return;
    } else if (type == 'env_yesno') {
      this.type = constEnv;
      return;
    }
    throw Exception('OverrideFormControl setType "$type" not implemented');
  }

  void setValue(String value) {
    textEditingController.text = value;
    this.value = value;
  }

  void setSubValueYes(String subValueYes) {
    this.subValueYes = subValueYes;
  }

  void setSubValueNo(String subValueNo) {
    this.subValueNo = subValueNo;
  }

  String getValue() {
    return textEditingController.text;
  }

  String getSubValueYesNo() {
    if (boolValue) {
      return subValueYes;
    }
    return subValueNo;
  }
}
