import 'dart:io';

import 'package:dupot_easy_flatpak/Domain/Entity/application_update_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/command_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:flutter/material.dart';

class UpdatesAvailablesView extends StatefulWidget {
  Function handleGoTo;
  UpdatesAvailablesView({super.key, required this.handleGoTo});

  @override
  State<UpdatesAvailablesView> createState() => _UpdatesAvailablesViewState();
}

class _UpdatesAvailablesViewState extends State<UpdatesAvailablesView> {
  List<ApplicationUpdate> stateApplicationUpdateList = [];
  List<ApplicationEntity> stateApplicationEntityList = [];

  Map<String, bool> stateCheckboxList = {};

  @override
  void initState() {
    // TODO: implement initState
    loadData();

    super.initState();
  }

  Future<void> loadData() async {
    Map<String, bool> checkboxList = {};

    List<ApplicationUpdate> applicationUpdateList =
        await CommandApi().checkUpdates();

    List<ApplicationUpdate> distinctApplicationUpdateList = [];

    List<String> applicationUpdateIdList = [];
    for (ApplicationUpdate applicationUpdateLoop in applicationUpdateList) {
      if (!applicationUpdateIdList
          .contains(applicationUpdateLoop.id.toLowerCase())) {
        applicationUpdateIdList.add(applicationUpdateLoop.id.toLowerCase());

        checkboxList[applicationUpdateLoop.id.toLowerCase()] = false;

        distinctApplicationUpdateList.add(applicationUpdateLoop);
      }
    }

    List<ApplicationEntity> applicationEntityList =
        await ApplicationRepository()
            .findListApplicationEntityByIdList(applicationUpdateIdList);

    setState(() {
      stateCheckboxList = checkboxList;

      stateApplicationUpdateList = distinctApplicationUpdateList;
      stateApplicationEntityList = applicationEntityList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: stateApplicationUpdateList
            .map((ApplicationUpdate applicationUpdate) =>
                getLine(applicationUpdate))
            .toList());
  }

  ApplicationEntity? getApplicationEntity(String id) {
    for (ApplicationEntity appLoop in stateApplicationEntityList) {
      if (appLoop.id.toLowerCase() == id.toLowerCase()) {
        return appLoop;
      }
    }
    return null;
  }

  Widget getLine(ApplicationUpdate applicationUpdate) {
    ApplicationEntity? applicationEntityFound =
        getApplicationEntity(applicationUpdate.id);

    return CheckboxListTile(
        onChanged: (bool? value) {
          Map<String, bool> checkboxList = stateCheckboxList;

          checkboxList[applicationUpdate.id.toLowerCase()] = value!;

          setState(() {
            stateCheckboxList = checkboxList;
          });
        },
        value: stateCheckboxList[applicationUpdate.id.toLowerCase()],
        title: Card(
          color: Theme.of(context).primaryColorLight,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  applicationEntityFound == null ||
                          !applicationEntityFound.hasAppIcon()
                      ? Image.asset('assets/images/no-image.png', height: 60)
                      : Image.file(
                          height: 60,
                          File(
                              '${UserSettingsEntity().getApplicationIconsPath()}/${applicationEntityFound.getAppIcon()}')),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicationEntityFound != null
                              ? applicationEntityFound.name
                              : applicationUpdate.id,
                          style: TextStyle(
                              fontSize: 26,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .color),
                        ),
                        Text(
                          applicationEntityFound != null
                              ? applicationEntityFound.summary
                              : '',
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
