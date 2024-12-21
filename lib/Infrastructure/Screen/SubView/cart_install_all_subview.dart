import 'dart:convert';
import 'dart:io';

import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/command_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/recipe_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Control/Model/SubView/override_control.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/override_form_control.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Button/close_subview_button.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Card/card_output_component.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Theme/theme_button_style.dart';
import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

class CartInstallAllSubview extends StatefulWidget {
  Function handleGoToApplicationInstalled;

  List<String> applicationIdListInCart;
  Function handleRemoveFromCart;
  Map<String, List<OverrideFormControl>> overrideSetupListByApplicationId;

  Function handleSetApplicationLighted;

  CartInstallAllSubview(
      {super.key,
      required this.handleGoToApplicationInstalled,
      required this.applicationIdListInCart,
      required this.handleRemoveFromCart,
      required this.overrideSetupListByApplicationId,
      required this.handleSetApplicationLighted});

  @override
  State<CartInstallAllSubview> createState() =>
      _InstallationWithRecipeViewState();
}

class _InstallationWithRecipeViewState extends State<CartInstallAllSubview> {
  bool stateIsInstalling = false;
  bool stateDisplayInstallButton = true;
  String stateInstallationOutput = '';

  String appPath = '';

  final ScrollController scrollController = ScrollController();

  bool stateIsLoaded = true;

  @override
  void initState() {
    install();
    super.initState();
  }

  Future<void> install() async {
    setState(() {
      stateIsInstalling = true;
    });

    OverrideControl overrideControl = OverrideControl();

    CommandApi command = CommandApi();
    String commandBin = 'flatpak';
    String flatpakCommand = 'flatpak';

    List<String> cartApplicationIdList =
        new List<String>.from(widget.applicationIdListInCart);

    for (String applicationIdLoop in cartApplicationIdList) {
      await widget.handleSetApplicationLighted(applicationIdLoop);
      List<String> commandArgList = [
        'install',
        '-y',
        'flathub',
        UserSettingsEntity().getInstallationScope(),
        applicationIdLoop
      ];

      Process process = await Process.start(command.getCommand(commandBin),
          command.getFlatpakSpawnArgumentList(commandBin, commandArgList));

      process.stdout.transform(utf8.decoder).listen((data) {
        print('STDOUT: $data');
        if (mounted) {
          setState(() {
            stateInstallationOutput = data;
          });
        }
      });

      await process.exitCode;

      if (widget.overrideSetupListByApplicationId
          .containsKey(applicationIdLoop)) {
        await overrideControl.save(applicationIdLoop,
            widget.overrideSetupListByApplicationId[applicationIdLoop]!);
      }

      await CommandApi().loadApplicationInstalledList();

      await widget.handleRemoveFromCart(applicationIdLoop);

      await widget.handleSetApplicationLighted('');

      setState(() {
        stateInstallationOutput = LocalizationApi().tr('installation_finished');
      });
    }

    setState(() {
      stateIsInstalling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              stateIsInstalling
                  ? const CircularProgressIndicator()
                  : CloseSubViewButton(
                      handle: widget.handleGoToApplicationInstalled),
              const SizedBox(width: 20)
            ],
          ),
          CardOutputComponent(outputString: stateInstallationOutput)
        ],
      ),
    );
  }

  Widget getInstallButton() {
    if (stateIsInstalling | !stateDisplayInstallButton) {
      return SizedBox();
    }

    return FilledButton.icon(
      style: ThemeButtonStyle(context: context).getButtonStyle(),
      onPressed: () {
        install();
        setState(() {
          stateDisplayInstallButton = false;
        });
      },
      label: Text(LocalizationApi().tr('install')),
      icon: const Icon(Icons.install_desktop),
    );
  }
}
