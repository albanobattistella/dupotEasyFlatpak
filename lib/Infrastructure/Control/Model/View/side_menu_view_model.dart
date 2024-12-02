import 'package:dupot_easy_flatpak/Infrastructure/Entity/menu_item_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Repository/application_repository.dart';
import 'package:flutter/material.dart';

class SideMenuViewModel {
  Function handleGoTo;

  SideMenuViewModel({required this.handleGoTo});

  Map<String, IconData> iconList = {
    'AudioVideo': Icons.play_circle,
    'Development': Icons.developer_board,
    'Education': Icons.school,
    'Game': Icons.gamepad,
    'Graphics': Icons.draw,
    'Network': Icons.network_check,
    'Office': Icons.document_scanner,
    'Science': Icons.science,
    'System': Icons.system_update_tv,
    'Utility': Icons.build,
  };

  Future<List<MenuItemEntity>> getMenuItemEntityList() async {
    List<String> categoryIdList =
        await ApplicationRepository().findAllCategoryList();

    List<MenuItemEntity> menuItemList = [];

    for (String categoryIdLoop in categoryIdList) {
      menuItemList.add(MenuItemEntity(
          label: categoryIdLoop,
          action: () {
            NavigationEntity.gotToCategoryId(
                handleGoTo: handleGoTo, categoryId: categoryIdLoop);
          },
          pageSelected: 'category',
          badge: '',
          categoryIdSelected: categoryIdLoop,
          icon: iconList[categoryIdLoop]!));
    }

    return menuItemList;
  }
}
