import 'package:dupot_easy_flatpak/Layout/content_with_sidemenu.dart';
import 'package:dupot_easy_flatpak/Layout/content_with_sidemenu_and_search.dart';
import 'package:dupot_easy_flatpak/Localizations/app_localizations_delegate.dart';
import 'package:dupot_easy_flatpak/Screens/loading.dart';
import 'package:dupot_easy_flatpak/Views/application_view.dart';
import 'package:dupot_easy_flatpak/Views/category_view.dart';
import 'package:dupot_easy_flatpak/Views/home_view.dart';
import 'package:dupot_easy_flatpak/Views/installation_view.dart';
import 'package:dupot_easy_flatpak/Views/installation_with_recipe_view.dart';
import 'package:dupot_easy_flatpak/Views/installedapps_view.dart';
import 'package:dupot_easy_flatpak/Views/search_view.dart';
import 'package:dupot_easy_flatpak/Views/uninstallation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class DupotEasyFlatpak extends StatefulWidget {
  const DupotEasyFlatpak({super.key});

  @override
  _DupotEasyFlatpakState createState() => _DupotEasyFlatpakState();
}

class _DupotEasyFlatpakState extends State<DupotEasyFlatpak> {
  String stateCategoryIdSelected = '';
  String stateApplicationIdSelected = '';
  String statePageSelected = '';
  String stateSearch = '';
  Locale stateLocale = const Locale.fromSubtags(languageCode: 'en');
  bool show404 = false;

  bool isDarkMode = false;

  static const String constPageCategory = 'category';
  static const String constPageApplication = 'application';
  static const String constPageHome = 'home';
  static const String constPageSearch = 'search';
  static const String constPageInstallation = 'installation';
  static const String constPageInstallationWithRecipe =
      'installationWithRecipe';
  static const String constPageUninstallation = 'uninstallation';
  static const String constPageInstalledApps = 'installedApps';

  @override
  Widget build(BuildContext context) {
    ColorScheme lightColorScheme =
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 54, 79, 148));

    ColorScheme darkColorScheme =
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 2, 0, 12));

    ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      primaryColor: lightColorScheme.primary,
      secondaryHeaderColor: lightColorScheme.secondary,
      canvasColor: lightColorScheme.surface,
      textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.black)),
      cardTheme: CardTheme(color: lightColorScheme.secondary),
      cardColor: lightColorScheme.surfaceBright,
      scaffoldBackgroundColor: lightColorScheme.primaryContainer,
      useMaterial3: true,
    );

    ThemeData darkTheme2 = ThemeData(
      brightness: Brightness.dark,
      primaryColor: lightColorScheme.primary,
      secondaryHeaderColor: lightColorScheme.secondary,
      canvasColor: lightColorScheme.surface,
      textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.black)),
      cardTheme: CardTheme(color: lightColorScheme.secondary),
      cardColor: lightColorScheme.surfaceTint,
      scaffoldBackgroundColor: lightColorScheme.primaryContainer,
      useMaterial3: true,
    );

    return MaterialApp(
      locale: stateLocale,
      theme: isDarkMode ? darkTheme2 : lightTheme,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      home: Navigator(
        pages: [
          if (statePageSelected == '')
            MaterialPage(
              key: const ValueKey('loading'),
              child: Loading(handle: _handleGoToHome),
            )
          else if (statePageSelected == constPageHome)
            MaterialPage(
                key: const ValueKey(constPageHome),
                child: ContentWithSidemenu(
                  content:
                      HomeView(handleGoToApplication: _handleGoToApplication),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageCategory &&
              stateCategoryIdSelected != '')
            MaterialPage(
                key: const ValueKey(constPageCategory),
                child: ContentWithSidemenu(
                  content: CategoryView(
                    categoryIdSelected: stateCategoryIdSelected,
                    handleGoToApplication: _handleGoToApplication,
                  ),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageSearch)
            MaterialPage(
                key: const ValueKey(constPageSearch),
                child: ContentWithSidemenuAndSearch(
                  content: SearchView(
                      categoryIdSelected: stateCategoryIdSelected,
                      handleGoToApplication: _handleGoToApplication,
                      searched: stateSearch),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  handleSearch: _handleSearch,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageApplication &&
              stateApplicationIdSelected != '')
            MaterialPage(
                key: const ValueKey(constPageApplication),
                child: ContentWithSidemenu(
                  content: ApplicationView(
                      applicationIdSelected: stateApplicationIdSelected,
                      handleGoToInstallation: _handleGoToInstallation,
                      handleGoToInstallationWithRecipe:
                          _handleGoToInstallationWithRecipe,
                      handleGoToUninstallation: _handleGoToUninstallation),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageInstallation &&
              stateApplicationIdSelected != '')
            MaterialPage(
                key: const ValueKey(constPageApplication),
                child: ContentWithSidemenu(
                  content: InstallationView(
                    applicationIdSelected: stateApplicationIdSelected,
                    handleGoToApplication: _handleGoToApplication,
                  ),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageUninstallation &&
              stateApplicationIdSelected != '')
            MaterialPage(
                key: const ValueKey(constPageApplication),
                child: ContentWithSidemenu(
                  content: UninstallationView(
                    applicationIdSelected: stateApplicationIdSelected,
                    handleGoToApplication: _handleGoToApplication,
                  ),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageInstallationWithRecipe &&
              stateApplicationIdSelected != '')
            MaterialPage(
                key: const ValueKey(constPageApplication),
                child: ContentWithSidemenu(
                  content: InstallationWithRecipeView(
                    applicationIdSelected: stateApplicationIdSelected,
                    handleGoToApplication: _handleGoToApplication,
                  ),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
          else if (statePageSelected == constPageInstalledApps)
            MaterialPage(
                key: const ValueKey(constPageApplication),
                child: ContentWithSidemenu(
                  content: InstalledAppsView(
                    handleGoToApplication: _handleGoToApplication,
                  ),
                  handleGoToHome: _handleGoToHome,
                  handleGoToCategory: _handleGoToCategory,
                  handleGoToSearch: _handleGoToSearch,
                  handleToggleDarkMode: _handleToggleDarkMode,
                  handleGoToInstalledApps: _handleGoToInstalledApps,
                  handleSetLocale: _handleSetLocale,
                  pageSelected: statePageSelected,
                  categoryIdSelected: stateCategoryIdSelected,
                ))
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }

  void _handleToggleDarkMode() {
    if (isDarkMode) {
      setState(() {
        isDarkMode = false;
      });
    } else {
      setState(() {
        isDarkMode = true;
      });
    }
  }

  void _handleGoToCategory(String categoryId) {
    setState(() {
      stateCategoryIdSelected = categoryId;
      statePageSelected = constPageCategory;
    });
  }

  void _handleGoToApplication(String applicationId) {
    setState(() {
      stateApplicationIdSelected = applicationId;
      statePageSelected = constPageApplication;
    });
  }

  void _handleGoToHome() {
    setState(() {
      statePageSelected = constPageHome;
      stateCategoryIdSelected = '';
    });
  }

  void _handleGoToSearch() {
    setState(() {
      statePageSelected = constPageSearch;
      stateCategoryIdSelected = '';
    });
  }

  void _handleGoToInstalledApps() {
    setState(() {
      statePageSelected = constPageInstalledApps;
      stateCategoryIdSelected = '';
      stateApplicationIdSelected = '';
    });
  }

  void _handleSearch(String newSearch) {
    setState(() {
      stateSearch = newSearch;
    });
  }

  void _handleGoToInstallation(String applicationId) {
    setState(() {
      statePageSelected = constPageInstallation;
      stateApplicationIdSelected = applicationId;
    });
  }

  void _handleGoToInstallationWithRecipe(String applicationId) {
    setState(() {
      statePageSelected = constPageInstallationWithRecipe;
      stateApplicationIdSelected = applicationId;
    });
  }

  void _handleGoToUninstallation(String applicationId) {
    setState(() {
      statePageSelected = constPageUninstallation;
      stateApplicationIdSelected = applicationId;
    });
  }

  void _handleSetLocale(String locale) {
    setState(() {
      stateLocale = Locale.fromSubtags(languageCode: locale);
    });
  }
}
