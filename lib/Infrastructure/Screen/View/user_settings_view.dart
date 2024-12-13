import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:flutter/material.dart';

class UserSettingsView extends StatefulWidget {
  Function handleGoTo;

  UserSettingsView({super.key, required this.handleGoTo});

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  ScrollController scrollController = ScrollController();

  bool isUserSettingsLoaded = false;
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
      isUserSettingsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //language
    //darkmode
    //scope install
    //installed app page (badge)
    return !isUserSettingsLoaded
        ? const CircularProgressIndicator()
        : Scrollbar(
            interactive: false,
            thumbVisibility: true,
            controller: scrollController,
            child: ListView(
              controller: scrollController,
              children: [
                Column(
                  children: [],
                )
              ],
            ));
  }
}
