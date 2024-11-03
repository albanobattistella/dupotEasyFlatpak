class Permission {
  final String type;
  final String label;
  final String? value;

  static const constTypeFileSystem = 'filesystem';
  static const constTypeFileSystemNoPrompt = 'filesystem_noprompt';

  static const constTypeInstallYesNo = 'install_flatpak_yesno';

  Permission(this.type, this.label, [this.value]);

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
