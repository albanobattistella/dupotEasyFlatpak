import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream.dart';
import 'package:flutter/material.dart';

class UninstallButton extends StatefulWidget {
  const UninstallButton(
      {super.key,
      required this.buttonStyle,
      required this.dialogButtonStyle,
      required this.stateAppStream,
      required this.handle});

  final ButtonStyle buttonStyle;
  final ButtonStyle dialogButtonStyle;
  final AppStream? stateAppStream;
  final Function handle;

  @override
  State<UninstallButton> createState() => _UninstallButtonState();
}

class _UninstallButtonState extends State<UninstallButton> {
  bool stateWillDeleteAppData = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: widget.buttonStyle,
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
                        style: widget.dialogButtonStyle,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations().tr('cancel'))),
                    FilledButton(
                        style: widget.dialogButtonStyle,
                        onPressed: () {
                          Navigator.of(context).pop();

                          widget.handle(widget.stateAppStream!.id,
                              stateWillDeleteAppData);
                        },
                        child: Text(AppLocalizations().tr('confirm'))),
                  ],
                  title: Text(AppLocalizations().tr('confirmation_title')),
                  contentPadding: const EdgeInsets.all(20.0),
                  content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Text(
                              '${AppLocalizations().tr('do_you_confirm_uninstallation_of')} ${widget.stateAppStream!.name} ?'),
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
                              Text(AppLocalizations().tr('delete_all_app_data'))
                            ],
                          )
                        ],
                      )),
                );
              });
            });

        //install(application);
      },
      label: Text(AppLocalizations().tr('uninstall')),
      icon: const Icon(Icons.delete_forever),
    );
  }
}
