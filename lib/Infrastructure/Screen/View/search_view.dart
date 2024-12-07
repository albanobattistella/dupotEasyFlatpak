import 'package:dupot_easy_flatpak/Domain/Entity/db/application_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Control/Model/View/search_view_model.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Entity/navigation_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Screen/SharedComponents/Content/application_list_content.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  Function handleGoTo;
  late String searched;
  SearchView({super.key, required this.handleGoTo, required this.searched});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<ApplicationEntity> stateAppStreamList = [];

  String stateSearch = '';

  String lastCategoryIdSelected = '';

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void didUpdateWidget(SearchView oldWidget) {
    if (oldWidget.searched != widget.searched) {
      loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadData() async {
    List<ApplicationEntity> applicationEntityList = await SearchViewModel()
        .getApplicationEntityListBySearch(widget.searched);
    setState(() {
      stateAppStreamList = applicationEntityList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        autofocus: true,
        controller: _searchController,
        style: Theme.of(context).textTheme.titleLarge,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: LocalizationApi().tr('Search...'),
          hintStyle: const TextStyle(color: Colors.black54),
        ),
        onChanged: (value) {
          NavigationEntity.goToSearch(
              handleGoTo: widget.handleGoTo, search: value);
        },
      ),
      Expanded(
          child: stateAppStreamList.isEmpty
              ? SizedBox()
              : ApplicationListContent(
                  handleGoTo: widget.handleGoTo,
                  applicationEntityList: stateAppStreamList))
    ]);
  }
}
