import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:dupot_easy_flatpak/Process/commands.dart';
import 'package:dupot_easy_flatpak/Process/first_installation.dart';
import 'package:dupot_easy_flatpak/Process/flathub_api.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  Loading({required this.handle});

  late Function handle;

  @override
  State<StatefulWidget> createState() => _Loading();
}

class _Loading extends State<Loading> with TickerProviderStateMixin {
  bool isLoaded = false;

  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    processInit();
  }

  Future<void> processInit() async {
    setState(() {
      progressValue = 0.1;
    });

    print('Installation');
    FirstInstallation firstInstallation =
        FirstInstallation(commands: Commands());
    await firstInstallation.process();
    print('End installation');

    setState(() {
      progressValue = 0.20;
    });

    final appStreamFactory = AppStreamFactory();
    //await appStreamFactory.create();

    FlathubApi flathubApi = FlathubApi(appStreamFactory: appStreamFactory);
    await flathubApi.load();

    setState(() {
      progressValue = 0.50;
    });

    if (!Commands().isInsideFlatpak() &&
        await Commands().missFlathubInFlatpak()) {
      print('need flathub');
      setState(() {
        progressValue = 0.6;
      });
      await Commands().setupFlathub();
    } else {
      print(' flathub ok');
    }

    await AppLocalizations().load();
    setState(() {
      progressValue = 0.7;
    });

    List<String> dbApplicationIdList =
        await appStreamFactory.findAllApplicationIdList();

    Commands().setDbApplicationIdList(dbApplicationIdList);
    await Commands().loadApplicationInstalledList();
    setState(() {
      progressValue = 0.8;
    });
    await Commands().checkUpdates();

    setState(() {
      progressValue = 1;
    });

    widget.handle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 205, 230, 250),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/logos/512x512.png'),
              LinearProgressIndicator(
                value: progressValue,
              )
            ],
          ),
        ));
  }
}
