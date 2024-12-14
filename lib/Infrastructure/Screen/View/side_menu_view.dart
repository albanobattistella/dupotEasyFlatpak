import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Control/Model/View/side_menu_view_model.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/menu_item_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/Theme/theme_text_style.dart';
import 'package:flutter/material.dart';

class SideMenuView extends StatefulWidget {
  String pageSelected;
  Map<String, String> argumentMapSelected;
  Function handleGoTo;

  int interfaceVersion = 0;

  SideMenuView(
      {super.key,
      required this.pageSelected,
      required this.argumentMapSelected,
      required this.handleGoTo,
      required this.interfaceVersion});

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
    loadData(true);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SideMenuView oldWidget) {
    if (oldWidget.pageSelected != widget.pageSelected ||
        (oldWidget.pageSelected == widget.pageSelected &&
            oldWidget.pageSelected == NavigationEntity.pageCategory &&
            oldWidget.argumentMapSelected![
                    NavigationEntity.argumentCategoryId]! !=
                widget.argumentMapSelected![
                    NavigationEntity.argumentCategoryId])) {
      loadData(false);
    } else if (oldWidget.interfaceVersion != widget.interfaceVersion) {
      loadData(false);
    }

    super.didUpdateWidget(oldWidget);
  }

  void loadData(bool shouldCheckUpdates) async {
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
            .getBottomMenuItemEntityList(shouldCheckUpdates);

    setState(() {
      stateBottomMenuItemList = bottomMenuItemList;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeTextStyle = ThemeTextStyle(context: context);

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Column(
          children: stateCategoryMenuItemList
              .map((menuItemLoop) => getMenuLine(menuItemLoop))
              .toList(),
        ),
        SizedBox(
          height: 28,
          child: ColoredBox(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        Column(
          children: stateBottomMenuItemList
              .map((menuItemLoop) => getMenuLine(menuItemLoop))
              .toList(),
        ),
      ],
    );
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
        visualDensity: const VisualDensity(vertical: -3),
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 0,
        tileColor: themeTextStyle.getHeadlineBackgroundColor(isSelected),
        titleTextStyle:
            TextStyle(color: themeTextStyle.getHeadlineTextColor(isSelected)),
        onTap: () {
          menuItemLoop.action();
        },
        title: Row(
          children: [
            menuItemLoop.badge.isNotEmpty
                ? IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Badge(
                        label: Text(menuItemLoop.badge),
                        backgroundColor: Colors.blueAccent,
                        child: Icon(menuItemLoop.icon,
                            color: themeTextStyle
                                .getHeadlineTextColor(isSelected))),
                    onPressed: null)
                : IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(menuItemLoop.icon,
                        color: themeTextStyle.getHeadlineTextColor(isSelected)),
                    onPressed: null,
                  ),
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
