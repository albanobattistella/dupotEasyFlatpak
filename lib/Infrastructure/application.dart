import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Layout/only_content_layout.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Layout/side_menu_with_content.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Layout/side_menu_with_content_and_subcontent.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/install_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/install_with_recipe_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/override_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/uninstall_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/update_available_processing_all_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/update_available_processing_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/application_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/category_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/home_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/installed_applications_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/loading_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/search_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/side_menu_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/updates_availables_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/user_settings_view.dart';
import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  static const String constOnlyContent = 'onlyContent';
  static const String constSideMenuWithContent = 'sideMenuWithContent';
  static const String constSideMenuWithContentAndSubContent =
      'sideMenuWithContentAndSubContent';

  static const Map<String, List<String>> layoutSetupList = {
    constOnlyContent: [NavigationEntity.pageLoading],
    constSideMenuWithContent: [
      //NavigationEntity.pageHome,
      NavigationEntity.pageCategory,
      NavigationEntity.pageApplication,
      NavigationEntity.pageInstalledApplication,
      NavigationEntity.pageSearch,
      NavigationEntity.pageUpdateAvailables,
      NavigationEntity.pageUserSettings
    ],
    constSideMenuWithContentAndSubContent: [
      NavigationEntity.argumentSubPageInstall,
      NavigationEntity.argumentSubPageInstallWithRecipe,
      NavigationEntity.argumentSubPageOverride,
      NavigationEntity.argumentSubPageUninstall,
      NavigationEntity.argumentSubPageUpdateAvailableProcessing,
      NavigationEntity.argumentSubPageUpdateAvailableProcessingAll
    ]
  };

  String statePage = NavigationEntity.pageLoading;
  Map<String, String> stateArgumentMap = {};
  String stateSearched = '';

  @override
  void initState() {
    print('init application');
    print('statePage: $statePage');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: Navigator(
          pages: [
            if (statePage == NavigationEntity.pageLoading)
              MaterialPage(
                  key: const ValueKey(NavigationEntity.pageLoading),
                  child: OnlyContentLayout(
                      handleGoTo: goTo,
                      content: LoadingView(handle: () {
                        NavigationEntity.goToHome(handleGoTo: goTo);
                      })))
            else
              MaterialPage(
                  key: const ValueKey(NavigationEntity.pageHome),
                  child: SideMenuWithContentLayout(
                      menu: getSideMenuView(),
                      content:
                          getContentView(NavigationEntity.pageHome, true))),
            if (layoutSetupList[constSideMenuWithContent]!.contains(statePage))
              MaterialPage(
                  key: ValueKey(statePage),
                  child: SideMenuWithContentLayout(
                      menu: getSideMenuView(),
                      content: getContentView(statePage, true))),
            if (stateArgumentMap
                    .containsKey(NavigationEntity.argumentSubPage) &&
                layoutSetupList[constSideMenuWithContentAndSubContent]!
                    .contains(NavigationEntity.extractArgumentSubPage(
                        stateArgumentMap)))
              MaterialPage(
                  key: ValueKey(NavigationEntity.extractArgumentSubPage(
                      stateArgumentMap)),
                  child: SideMenuWithContentAndSubContentLayout(
                    menu: getSideMenuView(),
                    content: getContentView(statePage, false),
                    subContent: getSubContentView(),
                  ))
          ],
          onDidRemovePage: (page) => false,
        ));
  }

  Widget getSideMenuView() {
    return SideMenuView(
      pageSelected: statePage,
      argumentMapSelected: stateArgumentMap,
      handleGoTo: goTo,
    );
  }

  Widget getContentView(String pageToLoad, bool isMain) {
    if (pageToLoad == NavigationEntity.pageHome) {
      return HomeView(handleGoTo: goTo);
    } else if (pageToLoad == NavigationEntity.pageCategory) {
      String newCategoryId =
          NavigationEntity.extractArgumentCategoryId(stateArgumentMap);

      return CategoryView(
        handleGoTo: goTo,
        categoryIdSelected: newCategoryId,
      );
    } else if (pageToLoad == NavigationEntity.pageApplication) {
      String newAppId =
          NavigationEntity.extractArgumentApplicationId(stateArgumentMap);

      return ApplicationView(
        handleGoTo: goTo,
        applicationIdSelected: newAppId,
        isMain: (!isMain ||
                stateArgumentMap.containsKey(NavigationEntity.argumentSubPage))
            ? false
            : true,
      );
    } else if (pageToLoad == NavigationEntity.pageInstalledApplication) {
      return InstalledApplicationsView(
        handleGoTo: goTo,
      );
    } else if (pageToLoad == NavigationEntity.pageSearch) {
      return SearchView(
        searched: stateSearched,
        handleGoTo: goTo,
      );
    } else if (pageToLoad == NavigationEntity.pageUpdateAvailables) {
      return UpdatesAvailablesView(
        handleGoTo: goTo,
        isMain: isMain,
      );
    } else if (pageToLoad == NavigationEntity.pageUserSettings) {
      return UserSettingsView(
        handleGoTo: goTo,
      );
    }

    throw new Exception('missing content view for statePage $statePage');
  }

  Widget getSubContentView() {
    String subPageToLoad = stateArgumentMap[NavigationEntity.argumentSubPage]!;

    if (subPageToLoad == NavigationEntity.argumentSubPageInstall) {
      String applicationId =
          NavigationEntity.extractArgumentApplicationId(stateArgumentMap);
      return InstallSubview(
          applicationId: applicationId,
          handleGoToApplication: () => NavigationEntity.gotToApplicationId(
              handleGoTo: goTo, applicationId: applicationId));
    } else if (subPageToLoad ==
        NavigationEntity.argumentSubPageInstallWithRecipe) {
      String applicationId =
          NavigationEntity.extractArgumentApplicationId(stateArgumentMap);
      return InstallWithRecipeSubview(
          applicationId: applicationId,
          handleGoToApplication: () => NavigationEntity.gotToApplicationId(
              handleGoTo: goTo, applicationId: applicationId));
    } else if (subPageToLoad == NavigationEntity.argumentSubPageUninstall) {
      String applicationId =
          NavigationEntity.extractArgumentApplicationId(stateArgumentMap);

      bool willDeleteAppData = false;
      if (stateArgumentMap.containsKey('willDeleteAppData')) {
        willDeleteAppData = true;
      }

      return UninstallSubview(
        applicationId: applicationId,
        handleGoToApplication: () => NavigationEntity.gotToApplicationId(
            handleGoTo: goTo, applicationId: applicationId),
        willDeleteAppData: willDeleteAppData,
      );
    } else if (subPageToLoad == NavigationEntity.argumentSubPageOverride) {
      String applicationId =
          NavigationEntity.extractArgumentApplicationId(stateArgumentMap);
      return OverrideSubview(
          applicationId: applicationId,
          handleGoToApplication: () => NavigationEntity.gotToApplicationId(
              handleGoTo: goTo, applicationId: applicationId));
    } else if (subPageToLoad ==
        NavigationEntity.argumentSubPageUpdateAvailableProcessing) {
      List<String> applicationIdSelectedList =
          NavigationEntity.extractArgumentApplicationIdSelectedList(
              stateArgumentMap);
      return UpdateAvailableProcessingSubview(
          applicationIdSelectedList: applicationIdSelectedList,
          handleGoTo: goTo);
    } else if (subPageToLoad ==
        NavigationEntity.argumentSubPageUpdateAvailableProcessingAll) {
      return UpdateAvailableProcessingAllSubview(handleGoTo: goTo);
    }
    throw new Exception(
        'missing content sub view for subPageToLoad $subPageToLoad');
  }

  void goTo({required String page, required Map<String, String> argumentMap}) {
    if (NavigationEntity.hasArgumentSearch(argumentMap)) {
      setState(() {
        stateSearched = NavigationEntity.extractArgumentSearch(argumentMap);
      });
    }

    setState(() {
      statePage = page;
      stateArgumentMap = argumentMap;
    });
  }
}
