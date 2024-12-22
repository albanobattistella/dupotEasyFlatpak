import 'package:flutter/material.dart';

class ThemeButtonStyle {
  BuildContext context;

  ThemeButtonStyle({required this.context});

  TextStyle getButtonTextStyle() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const TextStyle(fontSize: 14, color: Colors.white);
    }

    return const TextStyle(fontSize: 14, color: Colors.white);
  }

  ButtonStyle getSegmentedButtonStyle() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return SegmentedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        elevation: 0,
        side: const BorderSide(color: Colors.transparent, width: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: Colors.white54,
        selectedForegroundColor: Colors.white,
        selectedBackgroundColor: const Color.fromARGB(255, 27, 78, 112),
      );
    }

    return SegmentedButton.styleFrom(
      padding: const EdgeInsets.all(14),
      elevation: 0,
      side: const BorderSide(color: Colors.transparent, width: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      foregroundColor: Theme.of(context).primaryColor,
      selectedForegroundColor: Colors.white,
      selectedBackgroundColor: Theme.of(context).primaryColorDark,
    );
  }

  ButtonStyle getButtonStyle() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColorLight,
          padding: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          textStyle: getButtonTextStyle());
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
