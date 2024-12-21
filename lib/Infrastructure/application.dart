import 'package:dupot_easy_flatpak/Domain/Entity/user_settings_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Layout/only_content_layout.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Layout/side_menu_with_content_and_subcontent.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/install_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/install_with_recipe_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/override_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/uninstall_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/update_available_processing_all_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SubView/update_available_processing_subview.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/about_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/application_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/cart_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/category_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/home_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/installed_applications_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/loading_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/reload_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/search_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/side_menu_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/updates_availables_view.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/View/user_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      NavigationEntity.pageUserSettings,
      NavigationEntity.pageAbout,
      NavigationEntity.pageCart
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

  String statePreviousPage = NavigationEntity.pageHome;
  Map<String, String> statePreviousPArgumentMap = {};

  int stateInterfaceVersion = 0;

  List<String> stateApplicationIdListInCart = [];

  String version = '';

  final FocusNode _focusNode = FocusNode();

  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  @override
  void initState() {
    print('init application');
    print('statePage: $statePage');

    processInit();

    super.initState();
  }

  void processInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themData = ThemeData(
      useMaterial3: true,

      primaryColorLight: Colors.blueGrey,
      brightness: Brightness.dark,

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
    );

    bool hasSubContent = false;
    if (stateArgumentMap.containsKey(NavigationEntity.argumentSubPage)) {
      hasSubContent = true;
    }

    return KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (![
                NavigationEntity.argumentSubPageOverride,
                NavigationEntity.argumentSubPageInstallWithRecipe
              ].contains(getSubPage()) &&
              event is KeyDownEvent &&
              alphanumeric.hasMatch(event.logicalKey.keyLabel.toString())) {
            NavigationEntity.goToSearch(
                handleGoTo: goTo, search: event.logicalKey.keyLabel.toString());
          }
        },
        child: MaterialApp(
            theme: UserSettingsEntity().getActiveDarkModeEnabled()
                ? themData
                : ThemeData.light(),
            home: Navigator(
              pages: [
                if (statePage == NavigationEntity.pageLoading)
                  MaterialPage(
                      key: const ValueKey(NavigationEntity.pageLoading),
                      child: OnlyContentLayout(
                          handleGoTo: goTo,
                          content: LoadingView(handle: () {
                            goToPrevious();
                          })))
                else
                  MaterialPage(
                      key: ValueKey(NavigationEntity.extractArgumentSubPage(
                          stateArgumentMap)),
                      child: SideMenuWithContentAndSubContentLayout(
                        menu: getSideMenuView(),
                        content: getContentView(statePage, false),
                        subContent: getSubContentView(hasSubContent),
                        hasSubContent: hasSubContent,
                      ))
              ],
              onDidRemovePage: (page) => false,
            )));
  }

  String getSubPage() {
    if (stateArgumentMap.containsKey(NavigationEntity.argumentSubPage)) {
      return NavigationEntity.extractArgumentSubPage(stateArgumentMap);
    }
    return '';
  }

  Widget getSideMenuView() {
    return SideMenuView(
        interfaceVersion: stateInterfaceVersion,
        pageSelected: statePage,
        argumentMapSelected: stateArgumentMap,
        handleGoTo: goTo,
        applicationIdListInCart: stateApplicationIdListInCart);
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
        handleGoToPrevious: goToPrevious,
        handleAddToCart: addToCart,
        handleRemoveFromCart: removeFromCart,
        handleReload: reload,
        applicationIdListInCart: stateApplicationIdListInCart,
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
          handleReload: reload,
          handleReloadLanguage: reloadLanguage);
    } else if (pageToLoad == NavigationEntity.pageAbout) {
      return AboutView(
        version: version,
      );
    } else if (pageToLoad == NavigationEntity.pageCart) {
      return CartView(
        applicationIdListInCart: stateApplicationIdListInCart,
        handleGoTo: goTo,
        handleRemoveFromCart: removeFromCart,
        isMain: isMain,
      );
    }

    throw new Exception('missing content view for statePage $statePage');
  }

  reloadLanguage() {}

  Widget getSubContentView(bool hasSubContent) {
    if (!hasSubContent) {
      return const SizedBox();
    }

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

  void addToCart(String applicationId) {
    List<String> applicationIdList = stateApplicationIdListInCart;
    if (!applicationIdList.contains(applicationId)) {
      applicationIdList.add(applicationId);
    }

    setState(() {
      stateApplicationIdListInCart = applicationIdList;
    });
  }

  void removeFromCart(String applicationId) {
    List<String> applicationIdList = stateApplicationIdListInCart;
    if (applicationIdList.contains(applicationId)) {
      applicationIdList.remove(applicationId);
    }

    setState(() {
      stateApplicationIdListInCart = applicationIdList;
    });
  }

  void goToPrevious() {
    setState(() {
      statePage = statePreviousPage;
      stateArgumentMap = statePreviousPArgumentMap;
    });
  }

  void reload() {
    setState(() {
      stateInterfaceVersion = (stateInterfaceVersion + 1);
    });
  }

  void goTo({required String page, required Map<String, String> argumentMap}) {
    if (NavigationEntity.hasArgumentSearch(argumentMap)) {
      setState(() {
        stateSearched = NavigationEntity.extractArgumentSearch(argumentMap);
      });
    }

    setState(() {
      statePreviousPage = statePage;
      statePreviousPArgumentMap = stateArgumentMap;

      statePage = page;
      stateArgumentMap = argumentMap;
    });
  }
}
