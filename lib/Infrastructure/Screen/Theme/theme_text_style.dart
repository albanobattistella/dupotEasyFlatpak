import 'package:flutter/material.dart';

class ThemeTextStyle {
  BuildContext context;

  ThemeTextStyle({required this.context});

  Color getHeadlineTextColor(bool isSelected) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return isSelected ? Colors.white : Colors.black;
    }
    return isSelected
        ? Colors.white
        : Theme.of(context).textTheme.bodyMedium!.color!;
  }

  Color getHeadlineBackgroundColor(bool isSelected) {
    return isSelected
        ? Theme.of(context).primaryColorDark
        : Theme.of(context).primaryColorLight;
  }
}
