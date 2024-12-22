import 'package:flutter/material.dart';

class ThemeTextStyle {
  BuildContext context;

  ThemeTextStyle({required this.context});

  Color getBadgetTextColor(bool isSelected) {
    return Colors.white;
  }

  Color getHeadlineTextColor(bool isSelected) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return isSelected
          ? const Color.fromARGB(255, 167, 200, 223)
          : Colors.white;
    }
    return isSelected
        ? Colors.white
        : Theme.of(context).textTheme.bodyMedium!.color!;
  }

  Color getHeadlineBackgroundColor(bool isSelected) {
    return isSelected ? Theme.of(context).primaryColorDark : Colors.transparent;
  }
}
