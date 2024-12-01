import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Control/Model/View/side_menu_view_model.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/menu_item_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:flutter/material.dart';

class SideMenuView extends StatefulWidget {
  String pageSelected;
  Map<String, String> argumentMapSelected;
  Function handleGoTo;

  SideMenuView(
      {super.key,
      required this.pageSelected,
      required this.argumentMapSelected,
      required this.handleGoTo});

  @override
  State<SideMenuView> createState() => _SideMenuViewState();
}

class _SideMenuViewState extends State<SideMenuView> {
  List<MenuItemEntity> stateMenuItemList = [];
  String statePageSelected = '';
  String stateCategoryIdSelected = '';

  @override
  void initState() {
    // TODO: implement initState

    loadData();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SideMenuView oldWidget) {
    loadData();

    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  void loadData() async {
    List<MenuItemEntity> menuItemList =
        await SideMenuViewModel(handleGoTo: widget.handleGoTo)
            .getMenuItemEntityList();

    if (widget.pageSelected == 'category') {
      setState(() {
        statePageSelected = widget.pageSelected;
        stateCategoryIdSelected = widget.argumentMapSelected['categoryId']!;
      });
    } else {
      setState(() {
        statePageSelected = widget.pageSelected;
      });
    }

    setState(() {
      stateMenuItemList = menuItemList;
    });
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
              children: stateMenuItemList.map((menuItemLoop) {
                if (menuItemLoop.label == 'spacer') {
                  return const SizedBox(height: 100);
                }

                bool isSelected = false;
                if (menuItemLoop.pageSelected == statePageSelected &&
                    menuItemLoop.categoryIdSelected ==
                        stateCategoryIdSelected) {
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
                        Icon(menuItemLoop.icon),
                        const SizedBox(width: 8),
                        Text(
                          LocalizationApi().tr(menuItemLoop.label),
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
