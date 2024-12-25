import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Theme/theme_button_style.dart';
import 'package:flutter/material.dart';

class OverrideButton extends StatelessWidget {
  OverrideButton(
      {super.key,
      required this.applicationEntity,
      required this.handle,
      required this.isActive,
      required this.hasError});

  ApplicationEntity applicationEntity;
  Function handle;
  bool isActive;
  bool hasError;

  @override
  Widget build(BuildContext context) {
    ThemeButtonStyle themeButtonStyle = ThemeButtonStyle(context: context);

    return FilledButton.icon(
      style: themeButtonStyle.getButtonStyle(),
      onPressed: !isActive
          ? null
          : () {
              handle();
            },
      label: Text(LocalizationApi().tr('Edit_override'),
          style: themeButtonStyle.getButtonTextStyle()),
      icon: Icon(Icons.settings,
          color: hasError
              ? Colors.redAccent
              : themeButtonStyle.getButtonTextStyle().color),
    );
  }
}
