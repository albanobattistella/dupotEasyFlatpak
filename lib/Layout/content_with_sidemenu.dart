import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:dupot_easy_flatpak/Screens/Shared/menu_item.dart';
import 'package:dupot_easy_flatpak/Screens/Shared/my_drawer.dart';
import 'package:dupot_easy_flatpak/Screens/Shared/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ContentWithSidemenu extends StatefulWidget {
  final Widget content;
  final String pageSelected;
  final String categoryIdSelected;

  final Function handleGoToHome;
  final Function handleGoToCategory;
  final Function handleGoToSearch;
  final Function handleGoToInstalledApps;
  final Function handleToggleDarkMode;
  final Function handleSetLocale;

  const ContentWithSidemenu(
      {super.key,
      required this.content,
      required this.pageSelected,
      required this.categoryIdSelected,
      required this.handleGoToHome,
      required this.handleGoToCategory,
      required this.handleGoToSearch,
      required this.handleToggleDarkMode,
      required this.handleGoToInstalledApps,
      required this.handleSetLocale});

  @override
  _ContentWithSidemenuState createState() => _ContentWithSidemenuState();
}

class _ContentWithSidemenuState extends State<ContentWithSidemenu> {
  List<MenuItem> stateMenuItemList = [];

  String version = '';

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    AppStreamFactory appStreamFactory = AppStreamFactory();
    List<MenuItem> menuItemList = [
      MenuItem('Search', () {
        widget.handleGoToSearch();
      }, 'search', ''),
      MenuItem('Home', () {
        widget.handleGoToHome();
      }, 'home', ''),
      MenuItem('InstalledApps', () {
        widget.handleGoToInstalledApps();
      }, 'installedApps', '')
    ];
    List<String> categoryIdList = await appStreamFactory.findAllCategoryList();

    for (String categoryIdLoop in categoryIdList) {
      menuItemList.add(MenuItem(categoryIdLoop, () {
        widget.handleGoToCategory(categoryIdLoop);
      }, 'category', categoryIdLoop));

      setState(() {
        stateMenuItemList = menuItemList;
      });

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        //leading: const Icon(Icons.home),
        title: Text(
          'Easy Flatpak',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              color: Theme.of(context).primaryTextTheme.titleLarge!.color,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                widget.handleToggleDarkMode();
                print('siwth dark');
              },
              icon: Icon(Icons.dark_mode)),
        ],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            width: 240,
            child: SideMenu(
              menuItemList: stateMenuItemList,
              pageSelected: widget.pageSelected,
              categoryIdSelected: widget.categoryIdSelected,
            )),
        const SizedBox(width: 10),
        Expanded(child: widget.content),
      ]),
      drawer: MyDrawer(
        version: version,
        handleSetLocale: widget.handleSetLocale,
      ),
    );
  }
}
