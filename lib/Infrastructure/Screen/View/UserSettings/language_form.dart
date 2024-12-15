import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:flutter/material.dart';

class LanguageForm extends StatefulWidget {
  UserSettingsEntity userSettings;
  Function handleUpdateUserSettings;
  LanguageForm(
      {super.key,
      required this.userSettings,
      required this.handleUpdateUserSettings});

  @override
  State<LanguageForm> createState() => _LanguageFormState();
}

class _LanguageFormState extends State<LanguageForm> {
  updateLanguage(String language) {
    widget.userSettings.setLanguageCode(language);

    widget.handleUpdateUserSettings(widget.userSettings);
  }

  updateOverrideLanguage(bool override) {
    widget.userSettings.setUserOverrideLanguageCode(override);
    widget.handleUpdateUserSettings(widget.userSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            LocalizationApi().tr('Language'),
            style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge!.color),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Column(
            children: <Widget>[
              ListTile(
                titleTextStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.headlineLarge!.color),
                title: Text(LocalizationApi().tr('Use_system_language')),
                leading: Radio<bool>(
                  value: false,
                  groupValue: widget.userSettings.userOverrideLanguageCode,
                  onChanged: (bool? value) {
                    updateOverrideLanguage(false);
                  },
                ),
              ),
              ListTile(
                titleTextStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.headlineLarge!.color),
                title: Text(LocalizationApi().tr('Override_language')),
                leading: Radio<bool>(
                  value: true,
                  groupValue: widget.userSettings.userOverrideLanguageCode,
                  onChanged: (bool? value) {
                    updateOverrideLanguage(true);
                  },
                ),
              ),
              if (widget.userSettings.userOverrideLanguageCode)
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      children: [
                        ListTile(
                          titleTextStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .color),
                          title: Text(LocalizationApi().tr('English')),
                          leading: Radio<String>(
                            value: 'en',
                            groupValue:
                                widget.userSettings.getUserLanguageCode(),
                            onChanged: (String? value) {
                              updateLanguage('en');
                            },
                          ),
                        ),
                        ListTile(
                          titleTextStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .color),
                          title: Text(LocalizationApi().tr('French')),
                          leading: Radio<String>(
                            value: 'fr',
                            groupValue:
                                widget.userSettings.getUserLanguageCode(),
                            onChanged: (String? value) {
                              updateLanguage('fr');
                            },
                          ),
                        ),
                        ListTile(
                          titleTextStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .color),
                          title: Text(LocalizationApi().tr('Italian')),
                          leading: Radio<String>(
                            value: 'it',
                            groupValue:
                                widget.userSettings.getUserLanguageCode(),
                            onChanged: (String? value) {
                              updateLanguage('it');
                            },
                          ),
                        ),
                      ],
                    )),
            ],
          ),
        )
      ],
    );
  }
}
