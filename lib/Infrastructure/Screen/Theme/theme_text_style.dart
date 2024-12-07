import 'package:flutter/material.dart';

class ThemeTextStyle {
  BuildContext context;

  ThemeTextStyle({required this.context});

  Color getHeadlineTextColor(bool isSelected) {
    return isSelected
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge!.color!;
  }

  Color getHeadlineBackgroundColor(bool isSelected) {
    return isSelected
        ? Theme.of(context).primaryColorDark
        : Theme.of(context).primaryColorLight;
  }
}
