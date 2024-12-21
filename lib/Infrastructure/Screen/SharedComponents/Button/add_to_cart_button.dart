import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Button/dialog_cancel_button.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Button/dialog_confirm_button.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Theme/theme_button_style.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  AddToCartButton(
      {super.key,
      required this.applicationEntity,
      required this.handle,
      required this.isActive});

  ApplicationEntity applicationEntity;
  Function handle;
  bool isActive;

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
      label: Text(LocalizationApi().tr('add_to_cart'),
          style: themeButtonStyle.getButtonTextStyle()),
      icon: Icon(Icons.add_shopping_cart,
          color: themeButtonStyle.getButtonTextStyle().color),
    );
  }
}
