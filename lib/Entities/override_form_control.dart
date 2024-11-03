import 'package:flutter/material.dart';

class OverrideFormControl {
  late String label;
  late String type;
  late String value;
  TextEditingController textEditingController = TextEditingController();

  static const String constFileSystem = 'filesystem';

  void setLabel(String label) {
    this.label = label;
  }

  bool isTypeFileSystem() {
    return type == constFileSystem;
  }

  void setType(String type) {
    if (['filesystem_noprompt', 'filesystem'].contains(type)) {
      this.type = constFileSystem;
      return;
    }
    throw Exception('OverrideFormControl setType "$type" not implemented');
  }

  void setValue(String value) {
    textEditingController.text = value;
    this.value = value;
  }
}
