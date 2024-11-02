import 'dart:io';

import 'package:dupot_easy_flatpak/Models/Flathub/appstream.dart';
import 'package:dupot_easy_flatpak/Models/Flathub/appstream_factory.dart';
import 'package:flutter/material.dart';

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

class _CategoryViewState extends State<CategoryView> {
  List<AppStream> stateAppStreamList = [];
  List<String> stateCategoryIdList = [];
  String appPath = '';

  String lastCategoryIdSelected = '';

  final ScrollController scrollController = ScrollController();

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
        child: ListView.builder(
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
                                  File(
                                      '$appPath/${appStreamLoop.getAppIcon()}')),
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
            }));
  }
}
