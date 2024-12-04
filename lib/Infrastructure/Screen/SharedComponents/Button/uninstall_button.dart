import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Button/dialog_cancel_button.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Button/dialog_confirm_button.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Theme/theme_button_style.dart';
import 'package:flutter/material.dart';

class UninstallButton extends StatefulWidget {
  ApplicationEntity applicationEntity;
  Function handle;
  UninstallButton(
      {super.key, required this.applicationEntity, required this.handle});

  @override
  State<UninstallButton> createState() => _UninstallButtonState();
}

class _UninstallButtonState extends State<UninstallButton> {
  bool stateWillDeleteAppData = false;

  @override
  Widget build(BuildContext context) {
    bool stateWillDeleteAppData = false;

    ThemeButtonStyle themeButtonStyle = ThemeButtonStyle(context: context);

    return FilledButton.icon(
      style: themeButtonStyle.getButtonStyle(),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  buttonPadding: const EdgeInsets.all(10),
                  actions: [
                    FilledButton(
                        style: themeButtonStyle.getDialogButtonStyle(),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(LocalizationApi().tr('cancel'))),
                    FilledButton(
                        style: themeButtonStyle.getDialogButtonStyle(),
                        onPressed: () {
                          Navigator.of(context).pop();

                          widget.handle(widget.applicationEntity.id,
                              stateWillDeleteAppData);
                        },
                        child: Text(LocalizationApi().tr('confirm'))),
                  ],
                  title: Text(LocalizationApi().tr('confirmation_title')),
                  contentPadding: const EdgeInsets.all(20.0),
                  content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Text(
                              '${LocalizationApi().tr('do_you_confirm_uninstallation_of')} ${widget.applicationEntity.name} ?'),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Switch(
                                value: stateWillDeleteAppData,
                                onChanged: (bool value) {
                                  setState(() {
                                    stateWillDeleteAppData = value;
                                  });
                                },
                              ),
                              Text(LocalizationApi().tr('delete_all_app_data'))
                            ],
                          )
                        ],
                      )),
                );
              });
            });

        //install(application);
      },
      label: Text(LocalizationApi().tr('uninstall')),
      icon: const Icon(Icons.delete_forever),
    );
  }
}
