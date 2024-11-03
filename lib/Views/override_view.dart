import 'dart:convert';
import 'dart:io';

import 'package:dupot_easy_flatpak/Controls/override_control.dart';
import 'package:dupot_easy_flatpak/Entities/override_form_control.dart';
import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:dupot_easy_flatpak/Models/permission.dart';
import 'package:flutter/material.dart';
import "package:ini/ini.dart";

class OverrideView extends StatefulWidget {
  String applicationIdSelected;

  Function handleGoToApplication;

  OverrideView({
    super.key,
    required this.applicationIdSelected,
    required this.handleGoToApplication,
  });

  @override
  State<OverrideView> createState() => _OverrideViewState();
}

class _OverrideViewState extends State<OverrideView> {
  AppStream? stateAppStream;
  bool stateIsLoaded = true;
  String stateInstallationOutput = '';

  String applicationIdSelected = '';

  late Permission statePermission = Permission('', 'label');
  Config stateOverrideConfig = Config();

  String appPath = '';

  final ScrollController scrollController = ScrollController();

  List<OverrideFormControl> stateOverrideFormControlList = [];

  late OverrideControl overrideControl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    applicationIdSelected = widget.applicationIdSelected;
    AppStreamFactory appStreamFactory = AppStreamFactory();
    appPath = await appStreamFactory.getPath();

    AppStream appStream =
        await appStreamFactory.findAppStreamById(applicationIdSelected);

    await loadApplicationRecipeOverride(applicationIdSelected);

    setState(() {
      stateAppStream = appStream;
    });
  }

  Future<void> loadApplicationRecipeOverride(String applicationId) async {
    overrideControl = OverrideControl();
    List<OverrideFormControl> overrideFormControlList =
        await overrideControl.getOverrideControlList(applicationId);

    setState(() {
      stateOverrideFormControlList = overrideFormControlList;
      stateIsLoaded = false;
    });

    //print(flatpakOverrideApplication);
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle outputTextStyle =
        TextStyle(color: Colors.white, fontSize: 14.0);

    return stateAppStream == null
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
                  Row(
                    children: [
                      if (stateAppStream!.hasAppIcon())
                        Image.file(
                            File('$appPath/${stateAppStream!.getAppIcon()}')),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stateAppStream!.name,
                              style: const TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              stateAppStream!.developer_name,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            stateAppStream!.isVerified()
                                ? TextButton.icon(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 5,
                                            left: 0),
                                        alignment:
                                            AlignmentDirectional.topStart),
                                    icon: const Icon(Icons.verified),
                                    onPressed: () {},
                                    label: Text(
                                        stateAppStream!.getVerifiedLabel()))
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      stateIsLoaded
                          ? const CircularProgressIndicator()
                          : getButton(),
                      const SizedBox(width: 10),
                      stateIsLoaded ? const SizedBox() : getSaveButton(),
                      const SizedBox(width: 20)
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 800),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: stateOverrideFormControlList.map(
                                  (OverrideFormControl
                                      stateOverrideFormControlLoop) {
                                if (stateOverrideFormControlLoop
                                    .isTypeFileSystem()) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(stateOverrideFormControlLoop.label,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      TextField(
                                        controller: stateOverrideFormControlLoop
                                            .textEditingController,
                                      )
                                    ],
                                  );
                                } else if (stateOverrideFormControlLoop
                                    .isTypeEnv()) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(stateOverrideFormControlLoop.label,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          Switch(
                                            value: stateOverrideFormControlLoop
                                                .boolValue,
                                            onChanged: (bool value) {
                                              stateOverrideFormControlLoop
                                                  .boolValue = value;

                                              List<OverrideFormControl>
                                                  tmpOverrideFormControlList =
                                                  stateOverrideFormControlList;

                                              setState(() {
                                                stateOverrideFormControlList =
                                                    tmpOverrideFormControlList;
                                              });
                                            },
                                          ),
                                          Text(AppLocalizations().tr('Yes'))
                                        ],
                                      )
                                    ],
                                  );
                                }

                                return SizedBox();
                              }).toList()),
                        ),
                      )),
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
        widget.handleGoToApplication(widget.applicationIdSelected);
      },
      label: Text(AppLocalizations().tr('close')),
      icon: const Icon(Icons.close),
    );
  }

  Widget getSaveButton() {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(fontSize: 14));

    return FilledButton.icon(
      style: buttonStyle,
      onPressed: () async {
        await overrideControl.save(
            widget.applicationIdSelected, stateOverrideFormControlList);

        widget.handleGoToApplication(widget.applicationIdSelected);
      },
      label: Text(AppLocalizations().tr('save')),
      icon: const Icon(Icons.save),
    );
  }
}
