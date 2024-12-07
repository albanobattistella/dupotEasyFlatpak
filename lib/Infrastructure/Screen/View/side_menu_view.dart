import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Control/Model/View/side_menu_view_model.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/menu_item_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Theme/theme_text_style.dart';
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
  List<MenuItemEntity> stateCategoryMenuItemList = [];
  List<MenuItemEntity> stateBottomMenuItemList = [];
  String statePageSelected = '';
  String stateCategoryIdSelected = '';

  ScrollController scrollController = ScrollController();

  late ThemeTextStyle themeTextStyle;

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SideMenuView oldWidget) {
    loadData();

    super.didUpdateWidget(oldWidget);
  }

  void loadData() async {
    List<MenuItemEntity> categoryMenuItemList =
        await SideMenuViewModel(handleGoTo: widget.handleGoTo)
            .getCategoryMenuItemEntityList();

    if (widget.pageSelected == NavigationEntity.pageCategory) {
      setState(() {
        statePageSelected = widget.pageSelected;
        stateCategoryIdSelected =
            widget.argumentMapSelected[NavigationEntity.argumentCategoryId]!;
      });
    } else {
      setState(() {
        statePageSelected = widget.pageSelected;
      });
    }

    setState(() {
      stateCategoryMenuItemList = categoryMenuItemList;
    });

    List<MenuItemEntity> bottomMenuItemList =
        await SideMenuViewModel(handleGoTo: widget.handleGoTo)
            .getBottomMenuItemEntityList();

    setState(() {
      stateBottomMenuItemList = bottomMenuItemList;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeTextStyle = ThemeTextStyle(context: context);

    return Padding(
        padding: const EdgeInsets.all(5),
        child: Scrollbar(
            interactive: false,
            thumbVisibility: true,
            controller: scrollController,
            child: Card(
                color: Theme.of(context).primaryColorLight,
                margin: const EdgeInsets.all(0),
                elevation: 5,
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 20),
                    Column(
                      children: stateCategoryMenuItemList
                          .map((menuItemLoop) => getMenuLine(menuItemLoop))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: stateBottomMenuItemList
                          .map((menuItemLoop) => getMenuLine(menuItemLoop))
                          .toList(),
                    )
                  ],
                ))));
  }

  Widget getMenuLine(MenuItemEntity menuItemLoop) {
    bool isSelected = false;
    if (menuItemLoop.isCategory() &&
        menuItemLoop.pageSelected == statePageSelected &&
        menuItemLoop.categoryIdSelected == stateCategoryIdSelected) {
      isSelected = true;
    } else if (!menuItemLoop.isCategory() &&
        menuItemLoop.pageSelected == statePageSelected) {
      isSelected = true;
    }

    return ListTile(
        tileColor: themeTextStyle.getHeadlineBackgroundColor(isSelected),
        titleTextStyle:
            TextStyle(color: themeTextStyle.getHeadlineTextColor(isSelected)),
        onTap: () {
          menuItemLoop.action();
        },
        title: Row(
          children: [
            Icon(menuItemLoop.icon,
                color: themeTextStyle.getHeadlineTextColor(isSelected)),
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
  }
}
