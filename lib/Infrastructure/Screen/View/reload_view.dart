import 'package:dupot_easy_flatpak/Infrastructure/Api/command_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/flathub_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Control/Process/update_from_flathub_process.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:flutter/material.dart';

class ReloadView extends StatefulWidget {
  ReloadView({super.key, required this.handle});

  Function handle;

  @override
  State<StatefulWidget> createState() => _ReloadViewState();
}

class _ReloadViewState extends State<ReloadView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    processInit();
    super.dispose();
  }

  Future<void> processInit() async {
    widget.handle();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
