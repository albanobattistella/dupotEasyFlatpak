import 'dart:convert';
import 'dart:io';

import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:dupot_easy_flatpak/Process/commands.dart';
import 'package:dupot_easy_flatpak/Process/parameters.dart';
import 'package:flutter/material.dart';

class UpdateAllView extends StatefulWidget {
  Function handleGoBack;

  UpdateAllView({super.key, required this.handleGoBack});

  @override
  State<UpdateAllView> createState() => _UpdateAllViewState();
}

class _UpdateAllViewState extends State<UpdateAllView> {
  bool stateIsInstalling = false;
  String stateInstallationOutput = '';

  String applicationIdSelected = '';

  String appPath = '';

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    update();
  }

  Future<void> update() async {
    setState(() {
      stateIsInstalling = true;
    });
    Commands command = Commands();

    String commandBin = 'flatpak';
    List<String> commandArgList = [
      'update',
      '-y',
      Parameters().getInstallationScope(),
    ];

    Process.start(command.getCommand(commandBin),
            command.getFlatpakSpawnArgumentList(commandBin, commandArgList))
        .then((Process process) {
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

      process.exitCode.then((exitCode) {
        print('Exit code: $exitCode');
        Commands().loadApplicationInstalledList();
        Commands().checkUpdates().then(
          (value) {
            widget.handleGoBack();
          },
        );
      });
    }).catchError((e) {
      print('Error starting process: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle outputTextStyle =
        TextStyle(color: Colors.white, fontSize: 14.0);

    return !stateIsInstalling
        ? const CircularProgressIndicator()
        : Card(
            color: Theme.of(context).cardColor,
            child: Scrollbar(
              interactive: false,
              thumbVisibility: true,
              controller: scrollController,
              child: ListView(
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                        constraints: const BoxConstraints(minHeight: 800),
                        decoration: const BoxDecoration(color: Colors.blueGrey),
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: RichText(
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                style: outputTextStyle,
                                children: <TextSpan>[
                                  TextSpan(text: stateInstallationOutput),
                                ],
                              ),
                            ))),
                  ),
                ],
              ),
            ));
  }

  Widget getButton() {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(fontSize: 14));

    return FilledButton.icon(
      style: buttonStyle,
      onPressed: () {
        widget.handleGoBack();
      },
      label: Text(AppLocalizations().tr('close')),
      icon: const Icon(Icons.close),
    );
  }
}
