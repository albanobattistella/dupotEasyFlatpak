import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/radio_string_entity.dart';
import 'package:flutter/material.dart';

class RadioStringListSubform extends StatelessWidget {
  List<RadioStringEntity> radioStringEntityList;
  String value;
  Function handleUpdateValue;
  RadioStringListSubform(
      {super.key,
      required this.radioStringEntityList,
      required this.value,
      required this.handleUpdateValue});

  @override
  Widget build(BuildContext context) {
    return Column(
        spacing: 0,
        children: radioStringEntityList
            .map(
              (RadioStringEntity radioStringEntityLoop) => ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                titleTextStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.headlineLarge!.color),
                title: Text(LocalizationApi().tr(radioStringEntityLoop.label)),
                leading: Radio<String>(
                  value: radioStringEntityLoop.value,
                  groupValue: value,
                  onChanged: (String? value) {
                    handleUpdateValue(radioStringEntityLoop.value);
                  },
                ),
              ),
            )
            .toList());
  }
}
