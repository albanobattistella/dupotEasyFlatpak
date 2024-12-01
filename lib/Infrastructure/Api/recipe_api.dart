import 'dart:convert';

import 'package:dupot_easy_flatpak/Domain/Entity/recipe/recipe_entity.dart';
import 'package:dupot_easy_flatpak/Infrastructure/Api/localization_api.dart';
import 'package:flutter/services.dart';

class RecipeApi {
  static bool isDebug = true;

  Future<List<String>> getApplicationList() async {
    String recipiesString = await rootBundle.loadString("assets/recipies.json");
    List<String> recipeList = List<String>.from(json.decode(recipiesString));

    List<String> recipeLowerCaseList = [];
    for (String recipeId in recipeList) {
      recipeLowerCaseList.add(recipeId.toLowerCase());
    }

    return recipeLowerCaseList;
  }

  Future<RecipeEntity> getApplication(id) async {
    final languageCode = LocalizationApi().getLanguageCode();

    String applicaitonRecipieString = '';

    applicaitonRecipieString =
        await rootBundle.loadString("assets/recipies/$id.json");

    Map jsonApp = json.decode(applicaitonRecipieString);

    List<dynamic> rawList = jsonApp['flatpakPermissionToOverrideList'];

    if (jsonApp.containsKey('description_$languageCode')) {
      jsonApp['description'] = jsonApp['description_$languageCode'];
    }

    List<Map<String, dynamic>> objectList = [];
    for (Map<String, dynamic> rawLoop in rawList) {
      if (rawLoop.containsKey('label_$languageCode')) {
        rawLoop['label'] = rawLoop['label_$languageCode'];
      }
      objectList.add(rawLoop);
    }

    RecipeEntity applicationLoaded = RecipeEntity(id, objectList);

    return applicationLoaded;
  }
}
