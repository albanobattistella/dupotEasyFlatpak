import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Screens/Shared/menu_item.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu(
      {super.key,
      required this.menuItemList,
      required this.pageSelected,
      required this.categoryIdSelected});

  final List<MenuItem> menuItemList;
  final String pageSelected;
  final String categoryIdSelected;

  Widget getIcon(MenuItem menuItem) {
    if (menuItem.pageSelected == 'home') {
      return const Icon(Icons.home);
    } else if (menuItem.pageSelected == 'search') {
      return const Icon(Icons.search);
    } else if (menuItem.pageSelected == 'installedApps') {
      return const Icon(Icons.install_desktop);
    } else if (menuItem.pageSelected == 'updatesAvailable') {
      return Badge(
        label: Text(menuItem.badge),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.notifications),
      );
    } else if (menuItem.categoryIdSelected == 'AudioVideo') {
      return const Icon(Icons.music_note);
    } else if (menuItem.categoryIdSelected == 'Development') {
      return const Icon(Icons.developer_board);
    } else if (menuItem.categoryIdSelected == 'Education') {
      return const Icon(Icons.school);
    } else if (menuItem.categoryIdSelected == 'Game') {
      return const Icon(Icons.gamepad);
    } else if (menuItem.categoryIdSelected == 'Graphics') {
      return const Icon(Icons.draw);
    } else if (menuItem.categoryIdSelected == 'Network') {
      return const Icon(Icons.network_check);
    } else if (menuItem.categoryIdSelected == 'Office') {
      return const Icon(Icons.document_scanner);
    } else if (menuItem.categoryIdSelected == 'Science') {
      return const Icon(Icons.science);
    } else if (menuItem.categoryIdSelected == 'System') {
      return const Icon(Icons.system_update_tv);
    } else if (menuItem.categoryIdSelected == 'Utility') {
      return const Icon(Icons.build);
    }
    return const Icon(Icons.category);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
            color: Theme.of(context).primaryColorLight,
            margin: const EdgeInsets.all(0),
            elevation: 5,
            child: ListView(
              children: menuItemList.map((menuItemLoop) {
                bool isSelected = false;
                if (menuItemLoop.pageSelected == pageSelected &&
                    menuItemLoop.categoryIdSelected == categoryIdSelected) {
                  isSelected = true;
                }

                return ListTile(
                    tileColor: isSelected
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColorLight,
                    titleTextStyle: TextStyle(
                        color:
                            Theme.of(context).textTheme.headlineLarge!.color),

                    // selected: menuItemLoop.label == selected,
                    onTap: () {
                      menuItemLoop.action();
                    },
                    title: Row(
                      children: [
                        getIcon(menuItemLoop),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations().tr(menuItemLoop.label),
                          style: isSelected
                              ? TextStyle(
                                  backgroundColor: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionHandleColor)
                              : null,
                        ),
                      ],
                    ));
              }).toList(),
            )));
  }
}
