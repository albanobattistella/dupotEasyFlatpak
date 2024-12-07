import 'dart:io';

import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Card/card_application_component.dart';
import 'package:flutter/material.dart';

class ListviewApplicationListComponent extends StatelessWidget {
  List<ApplicationEntity> applicationEntityList;
  Function handleGoTo;

  ScrollController handleScrollController;

  ListviewApplicationListComponent(
      {super.key,
      required this.applicationEntityList,
      required this.handleGoTo,
      required this.handleScrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: applicationEntityList.length,
        controller: handleScrollController,
        itemBuilder: (context, index) {
          ApplicationEntity appStreamLoop = applicationEntityList[index];

          return InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                NavigationEntity.gotToApplicationId(
                    handleGoTo: handleGoTo, applicationId: appStreamLoop.id);
              },
              child: Card(
                color: Theme.of(context).primaryColorLight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        !appStreamLoop.hasAppIcon()
                            ? Image.asset('assets/images/no-image.png',
                                height: 60)
                            : Image.file(
                                height: 60,
                                File(
                                    '${UserSettingsEntity().getApplicationIconsPath()}/${appStreamLoop.getAppIcon()}')),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appStreamLoop.name,
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .color),
                              ),
                              Text(
                                appStreamLoop.summary,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
