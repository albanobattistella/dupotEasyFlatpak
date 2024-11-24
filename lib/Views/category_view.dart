import 'dart:io';

import 'package:dupot_easy_flatpak/Localizations/app_localizations.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:dupot_easy_flatpak/Screens/Shared/app_button.dart';
import 'package:dupot_easy_flatpak/Screens/Store/block.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CategoryView extends StatefulWidget {
  String categoryIdSelected;
  late Function handleGoToApplication;
  CategoryView(
      {super.key,
      required this.categoryIdSelected,
      required this.handleGoToApplication});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

enum AppDisplay { list, grid }

const List<(AppDisplay, IconData)> appDisplayOptions = <(AppDisplay, IconData)>[
  (AppDisplay.list, Icons.view_list),
  (AppDisplay.grid, Icons.view_compact),
];

class _CategoryViewState extends State<CategoryView> {
  List<AppStream> stateAppStreamList = [];
  List<String> stateCategoryIdList = [];
  String appPath = '';

  String lastCategoryIdSelected = '';

  final ScrollController scrollController = ScrollController();

  Set<AppDisplay> _segmentedButtonSelection = <AppDisplay>{AppDisplay.list};

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    lastCategoryIdSelected = widget.categoryIdSelected;
    AppStreamFactory appStreamFactory = AppStreamFactory();
    appPath = await appStreamFactory.getPath();

    List<AppStream> appStreamList = await appStreamFactory
        .findListAppStreamByCategory(widget.categoryIdSelected);

    setState(() {
      stateAppStreamList = appStreamList;
    });
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lastCategoryIdSelected != widget.categoryIdSelected) {
      loadData();
    }

    return Scrollbar(
        interactive: false,
        thumbVisibility: true,
        controller: scrollController,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(children: [
                  Expanded(child: SizedBox()),
                  SegmentedButton<AppDisplay>(
                    // ToggleButtons above allows multiple or no selection.
                    // Set `multiSelectionEnabled` and `emptySelectionAllowed` to true
                    // to match the behavior of ToggleButtons.
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: false,

                    // Hide the selected icon to match the behavior of ToggleButtons.
                    showSelectedIcon: true,
                    // SegmentedButton uses a Set<T> to track its selection state.
                    selected: _segmentedButtonSelection,
                    // This callback updates the set of selected segment values.
                    onSelectionChanged: (Set<AppDisplay> newSelection) {
                      setState(() {
                        _segmentedButtonSelection = newSelection;
                      });
                    },
                    // SegmentedButton uses a List<ButtonSegment<T>> to build its children
                    // instead of a List<Widget> like ToggleButtons.
                    segments: appDisplayOptions.map<ButtonSegment<AppDisplay>>(
                        ((AppDisplay, IconData) shirt) {
                      return ButtonSegment<AppDisplay>(
                          value: shirt.$1, label: Icon(shirt.$2));
                    }).toList(),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ])),
            Expanded(
              child: _segmentedButtonSelection.first == AppDisplay.grid
                  ? getGridView()
                  : getListView(),
            )
          ],
        ));
  }

  Widget getGridView() {
    return GridView.builder(
      itemCount: stateAppStreamList.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        AppStream appStreamLoop = stateAppStreamList[index];

        String icon = '';
        if (appStreamLoop.hasAppIcon()) {
          icon = '$appPath/${appStreamLoop.getAppIcon()}';
        }

        return Container(
            width: 150,
            height: 150,
            child: AppButton(
                id: appStreamLoop.id,
                title: appStreamLoop.name,
                sumary: appStreamLoop.summary,
                icon: icon,
                handle: widget.handleGoToApplication));
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200),
    );
  }

  Widget getListView() {
    return ListView.builder(
        itemCount: stateAppStreamList.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          AppStream appStreamLoop = stateAppStreamList[index];

          if (!appStreamLoop.hasAppIcon()) {
            return Card(
              child: Column(
                children: [
                  ListTile(title: Text(stateAppStreamList[index].id)),
                ],
              ),
            );
          } else {
            return InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  widget.handleGoToApplication(appStreamLoop.id);
                },
                child: Card(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Image.file(
                              height: 80,
                              File('$appPath/${appStreamLoop.getAppIcon()}')),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStreamLoop.name,
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .color),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  appStreamLoop.summary,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ));
          }
        });
  }
}
