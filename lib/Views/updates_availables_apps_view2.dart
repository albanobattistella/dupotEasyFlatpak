import 'dart:io';

import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:dupot_easy_flatpak/Process/commands.dart';
import 'package:dupot_easy_flatpak/Screens/Store/update_all_button.dart';
import 'package:flutter/material.dart';

class UpdatesAvailablesAppsView2 extends StatefulWidget {
  final Function handleGoToApplication;
  final Function handleGoToUpdateAll;
  const UpdatesAvailablesAppsView2(
      {super.key,
      required this.handleGoToApplication,
      required this.handleGoToUpdateAll});

  @override
  State<UpdatesAvailablesAppsView2> createState() =>
      _UpdatesAvailablesAppsViewState();
}

class _UpdatesAvailablesAppsViewState
    extends State<UpdatesAvailablesAppsView2> {
  List<AppStream> stateAppStreamList = [];
  String appPath = '';

  String stateSearch = '';

  String lastCategoryIdSelected = '';

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    AppStreamFactory appStreamFactory = AppStreamFactory();
    appPath = await appStreamFactory.getPath();

    print(Commands().getAppIdUpdateAvailableList());

    List<AppStream> appStreamList = await appStreamFactory
        .findListAppStreamByIdList(Commands().getAppIdUpdateAvailableList());

    setState(() {
      stateAppStreamList = appStreamList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return stateAppStreamList.isEmpty
        ? Center(
            child: Text(
            AppLocalizations().tr('NoUpdates'),
          ))
        : Scrollbar(
            interactive: false,
            thumbVisibility: true,
            controller: scrollController,
            child: ListView(controller: scrollController, children: [
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: SizedBox(width: 10)),
                  getUpdateAllButton(),
                  SizedBox(width: 5)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                  children: stateAppStreamList.map((appStreamLoop) {
                if (!appStreamLoop.hasAppIcon()) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(
                          appStreamLoop.id,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .color),
                        )),
                      ],
                    ),
                  );
                } else {
                  return InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        widget.handleGoToApplication(appStreamLoop.id);
                      },
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Image.file(
                                    height: 80,
                                    File(
                                        '$appPath/${appStreamLoop.getAppIcon()}')),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appStreamLoop.name,
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .color),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        appStreamLoop.summary,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(Commands().getAppUpdateVersionByAppId(
                                    appStreamLoop.id)),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),
                      ));
                }
              }).toList())
            ]));
  }

  Widget getUpdateAllButton() {
    final ButtonStyle dialogButtonStyle = FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(fontSize: 14));

    return UpdateAllButton(
      buttonStyle: getButtonStyle(context),
      dialogButtonStyle: dialogButtonStyle,
      handle: widget.handleGoToUpdateAll,
    );
  }

  ButtonStyle getButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.all(16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: const TextStyle(fontSize: 14, color: Colors.white));
  }
}
