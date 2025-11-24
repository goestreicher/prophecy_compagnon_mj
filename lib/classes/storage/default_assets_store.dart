import 'dart:convert';

import 'package:flutter/services.dart';

import '../object_location.dart';

Future<List<dynamic>> loadJSONAssetObjectList(String file) async {
  var jsonStr = await rootBundle.loadString('assets/$file');
  var assets = json.decode(jsonStr);
  var ret = [];
  for(var asset in assets) {
    if(asset is Map) {
      asset['location'] = ObjectLocation(
        type: ObjectLocationType.assets,
        collectionUri: file,
      ).toJson();
      ret.add(asset);
    }
  }
  return ret;
}

Future<Map<String, dynamic>?> loadJsonAssetObject(String file, String uuid, String Function(Map<String, dynamic>) getId) async {
  var jsonStr = await rootBundle.loadString('assets/$file');
  var assets = json.decode(jsonStr);
  Map<String, dynamic>? ret;
  for(var asset in assets) {
    if(asset is Map && uuid == getId(asset as Map<String, dynamic>)) {
      ret = asset;
      ret['location'] = ObjectLocation(
        type: ObjectLocationType.assets,
        collectionUri: file,
      ).toJson();
      break;
    }
  }
  return ret;
}