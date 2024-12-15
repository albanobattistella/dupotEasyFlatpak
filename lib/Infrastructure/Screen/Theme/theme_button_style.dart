import 'package:flutter/material.dart';

class ThemeButtonStyle {
  BuildContext context;

  ThemeButtonStyle({required this.context});

  ButtonStyle getButtonStyle() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColorLight,
          padding: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          textStyle: const TextStyle(fontSize: 14, color: Colors.white));
    }

    return ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColorDark,
        padding: const EdgeInsets.all(16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: const TextStyle(fontSize: 14, color: Colors.white));
  }

  ButtonStyle getDialogButtonStyle() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          padding: const EdgeInsets.all(20),
          textStyle: const TextStyle(fontSize: 14, color: Colors.black));
    }
    return FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(fontSize: 14));
  }
}
