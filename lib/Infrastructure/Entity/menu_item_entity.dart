import 'package:flutter/material.dart';

class MenuItemEntity {
  MenuItemEntity(
      {required this.label,
      required this.action,
      required this.pageSelected,
      required this.categoryIdSelected,
      required this.badge,
      required this.icon});

  String label;
  Function action;
  String pageSelected;
  String categoryIdSelected;
  String badge;
  IconData icon;
}
