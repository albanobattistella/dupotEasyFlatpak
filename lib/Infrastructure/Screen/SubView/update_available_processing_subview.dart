import 'dart:convert';
import 'dart:io';

import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/command_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Button/close_subview_button.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Card/card_output_component.dart';
import 'package:flutter/material.dart';

class UpdateAvailableProcessingSubview extends StatefulWidget {
  Function handleGoTo;
  List<String> applicationIdSelectedList;

  UpdateAvailableProcessingSubview(
      {super.key,
      required this.handleGoTo,
      required this.applicationIdSelectedList});

  @override
  State<UpdateAvailableProcessingSubview> createState() =>
      _UpdateAvailableProcessingSubviewState();
}

class _UpdateAvailableProcessingSubviewState
    extends State<UpdateAvailableProcessingSubview> {
  bool stateIsInstalling = true;
  String stateInstallationOutput = '';

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    updateList(widget.applicationIdSelectedList);
  }

  Future<void> updateList(List<String> applicationIdSelectedList) async {
    CommandApi command = CommandApi();

    for (String applicationIdSelectedLoop in applicationIdSelectedList) {
      String commandBin = 'flatpak';
      List<String> commandArgList = [
        'update',
        '-y',
        UserSettingsEntity().getInstallationScope(),
        applicationIdSelectedLoop
      ];

      Process process = await Process.start(command.getCommand(commandBin),
          command.getFlatpakSpawnArgumentList(commandBin, commandArgList));

      process.stdout.transform(utf8.decoder).listen((data) {
        print('STDOUT: $data');
        setState(() {
          stateInstallationOutput = data;
        });
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        print('STDERR: $data');
        setState(() {
          stateInstallationOutput = data;
        });
      });
    }

    setState(() {
      stateInstallationOutput =
          "$stateInstallationOutput \n ${LocalizationApi().tr('installation_finished')}";
      stateIsInstalling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle outputTextStyle =
        TextStyle(color: Colors.white, fontSize: 14.0);

    return Scrollbar(
      interactive: false,
      thumbVisibility: true,
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 20),
              stateIsInstalling
                  ? const CircularProgressIndicator()
                  : CloseSubViewButton(
                      applicationId: '',
                      handle: () {
                        NavigationEntity.goToUpdatesAvailables(
                            handleGoTo: widget.handleGoTo);
                      }),
              const SizedBox(width: 20)
            ],
          ),
          CardOutputComponent(outputString: stateInstallationOutput),
        ],
      ),
    );
  }
}
