import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:flutter/material.dart';

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({super.key});

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  ScrollController scrollController = ScrollController();

  late UserSettingsEntity stateUserSettingsEntity;

  @override
  void initState() {
    // TODO: implement initState
    loadData();

    super.initState();
  }

  Future<void> loadData() async {
    setState(() {
      stateUserSettingsEntity = UserSettingsEntity();
    });
  }

  @override
  Widget build(BuildContext context) {
    //language
    //darkmode
    //scope install
    //installed app page (badge)
    return stateUserSettingsEntity == null
        ? CircularProgressIndicator()
        : Scrollbar(
            interactive: false,
            thumbVisibility: true,
            controller: scrollController,
            child: Column(
              children: [],
            ));
  }
}
