class PermissionEntity {
  final String type;
  final String label;
  final String? value;
  final String? subValueYes;
  final String? subValueNo;

  static const constTypeFileSystem = 'filesystem';
  static const constTypeFileSystemNoPrompt = 'filesystem_noprompt';

  static const constTypeInstallYesNo = 'install_flatpak_yesno';

  PermissionEntity(this.type, this.label,
      [this.value, this.subValueYes, this.subValueNo]);

  bool isFileSystem() {
    return (type == constTypeFileSystem);
  }

  bool isFileSystemNoPrompt() {
    return (type == constTypeFileSystemNoPrompt);
  }

  bool isInstallFlatpakYesNo() {
    return (type == constTypeInstallYesNo);
  }

  String getType() {
    return type;
  }

  String getLabel() {
    return label;
  }

  String? getValue() {
    return value;
  }

  String? getSubValueYes() {
    return subValueYes;
  }

  String? getSubValueNo() {
    return subValueNo;
  }

  String getFlatpakOverrideType() {
    if (isFileSystemNoPrompt()) {
      return getFlatpakParameter(constTypeFileSystem);
    }

    return getFlatpakParameter(type);
  }

  String getFlatpakParameter(String parameter) {
    return '--$parameter=';
  }
}
