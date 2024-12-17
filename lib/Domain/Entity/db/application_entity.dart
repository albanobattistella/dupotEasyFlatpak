import 'dart:convert';

import 'package:intl/intl.dart';

class ApplicationEntity {
  final String id;
  final String name;
  final String summary;
  final String httpIcon;

  List<String> categoryIdList = [];
  String description = '';

  Map<String, dynamic> metadataObj = {};
  Map<String, dynamic> urlObj = {};
  List<dynamic> releaseObjList = [];
  int lastUpdate = 0;

  String developer_name;

  String projectLicense;

  List<dynamic> screenshotObjList = [];

  int lastReleaseTimestamp = 0;

  bool isAlreadyInstalled = false;
  bool hasRecipe = false;
  bool isOverrided = false;
  bool hasUpdate = false;

  bool isEmpty = false;

  ApplicationEntity(
      {required this.id,
      required this.name,
      required this.summary,
      required this.httpIcon,
      required this.categoryIdList,
      required this.description,
      required this.metadataObj,
      required this.urlObj,
      required this.releaseObjList,
      required this.lastUpdate,
      required this.projectLicense,
      required this.developer_name,
      required this.screenshotObjList,
      required this.lastReleaseTimestamp});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'icon': httpIcon,
      'categoryIdList': jsonEncode(categoryIdList),
      'description': description,
      'metadataObj': jsonEncode(metadataObj),
      'urlObj': jsonEncode(urlObj),
      'releaseObjList': jsonEncode(releaseObjList),
      'lastUpdate': lastUpdate,
      'projectLicense': projectLicense,
      'developer_name': developer_name,
      'screenshotList': jsonEncode(screenshotObjList),
      'lastReleaseTimestamp': lastReleaseTimestamp
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'AppStream{id: $id, name: $name, summary: $summary}';
  }

  bool isVerified() {
    if (metadataObj.containsKey('flathub_verified') &&
        metadataObj['flathub_verified']) {
      return true;
    }
    print(metadataObj);
    return false;
  }

  String formatMB(int value) {
    final f = NumberFormat("###.00");
    return f.format(value / 1000000).replaceAll('.00', '');
  }

  String getDownloadSize() {
    if (metadataObj.containsKey('download_size')) {
      return '${formatMB(metadataObj['download_size'])} MB';
    }
    return '-';
  }

  String getInstalledSize() {
    if (metadataObj.containsKey('installed_size')) {
      return '${formatMB(metadataObj['installed_size'])} MB';
    }
    return '-';
  }

  String getVerifiedLabel() {
    if (metadataObj.containsKey('flathub_verified_label')) {
      return metadataObj['flathub_verified_label'];
    }
    return ' ';
  }

  String getVerifiedUrl() {
    if (metadataObj.containsKey('flathub_verified_url')) {
      return metadataObj['flathub_verified_url'];
    }
    return '';
  }

  List<Map<String, dynamic>> getReleaseObjList() {
    List<Map<String, dynamic>> releaseMapList = [];

    int limit = 0;
    for (dynamic rawReleaseObjLoop in releaseObjList) {
      releaseMapList.add({
        'version': rawReleaseObjLoop['version'],
        'timestamp': rawReleaseObjLoop['timestamp']
      });

      limit++;
      if (limit > 6) break;
    }

    return releaseMapList;
  }

  List<Map<String, String>> getUrlObjList() {
    List<Map<String, String>> urlObjList = [];

    List<String> keyList = [
      'homepage',
      'bugtracker',
      'vcs_browser',
      'contribute'
    ];

    for (String keyLoop in keyList) {
      if (urlObj.containsKey(keyLoop)) {
        urlObjList.add({'key': keyLoop, 'value': urlObj[keyLoop].toString()});
      }
    }

    return urlObjList;
  }

  bool hasAppIcon() {
    return httpIcon.length > 10;
  }

  String getAppIcon() {
    return '${id.toLowerCase()}.png';
  }

  bool lastUpdateIsOlderThan(int days) {
    if ((DateTime.now().millisecondsSinceEpoch - lastUpdate) >
        days * 86400000) {
      return true;
    }
    return false;
  }
}
